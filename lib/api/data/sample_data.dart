const dynamic PROBLEM_LIST = [
  {
    "id": 4,
    "title": "Communication!",
    "description":
        "Not able to talk or communicate to the other floors or room for any thing",
    "images": [
      {
        "image_url":
            "https://media.istockphoto.com/id/1406124833/vector/problems-in-communication-vector-concept.jpg?s=612x612&w=0&k=20&c=Bc_PujLiEKfNOOuI0A2TYG-phmBhu6z4WgHaVEsPnR8=",
        "thumbnail_url":
            "https://www.alert-software.com/hs-fs/hubfs/communication_problems_in_the_workplace.png?width=1280&name=communication_problems_in_the_workplace.png"
      },
      {
        "image_url":
            "https://clariti.b-cdn.net/wp-content/uploads/2025/05/How-to-solve-your-business-communication-problems.jpg",
        "thumbnail_url":
            "https://blogimage.vantagecircle.com/content/images/2022/12/Consistent-communication.png"
      },
    ],
    "image_url":
        "https://www.alert-software.com/hs-fs/hubfs/communication_problems_in_the_workplace.png?width=1280&name=communication_problems_in_the_workplace.png",
    "thumbnail_url":
        "https://www.alert-software.com/hs-fs/hubfs/communication_problems_in_the_workplace.png?width=1280&name=communication_problems_in_the_workplace.png",
    "avatar_url":
        "https://www.alert-software.com/hs-fs/hubfs/communication_problems_in_the_workplace.png?width=1280&name=communication_problems_in_the_workplace.png",
  }
];

const COMMENT_LIST = [
  {
    "user_name": "John Doe",
    "content":
        "I've been having communication issues with my team. Can you help me solve this?",
    "timestamp": "2022-09-12T15:30:00Z",
    "likes": 5,
    "avatar_url":
        "https://static.vecteezy.com/system/resources/thumbnails/012/177/618/small/man-avatar-isolated-png.png",
    "replies": [
      {
        "username": "Jane Smith",
        "comment": "Yes, I can help. What specific issues are you facing?",
        "timestamp": "2022-09-12T15:45:00Z",
        "likes": 3,
        "replies": ["Reply 1", "Reply 2", "Reply 3"]
      }
    ]
  },
  {
    "user_name": "Jane Smith",
    "content":
        "I've been having trouble with my team communication. What can I do to improve it?",
    "timestamp": "2022-09-12T16:00:00Z",
    "likes": 7,
    "avatar_url":
        "https://static.vecteezy.com/system/resources/thumbnails/012/177/618/small/man-avatar-isolated-png.png",
    "replies": [
      {
        "username": "John Doe",
        "comment":
            "I agree. Let's start by setting clear expectations and communicating clearly.",
        "timestamp": "2022-09-12T16:15:00Z",
        "likes": 2,
        "replies": []
      }
    ]
  },
  {
    "username": "John Doe",
    "comment":
        "I've been having communication issues with my team. Can you help me solve this?",
    "timestamp": "2022-09-12T15:30:00Z",
    "likes": 5,
    "avatar_url":
        "https://static.vecteezy.com/system/resources/thumbnails/012/177/618/small/man-avatar-isolated-png.png",
    "replies": [
      {
        "username": "Jane Smith",
        "comment": "Yes, I can help. What specific issues are you facing?",
        "timestamp": "2022-09-12T15:45:00Z",
        "likes": 3,
        "replies": ["Reply 1", "Reply 2", "Reply 3"]
      }
    ]
  },
];

const DATA_PROBLEM_REQUIREMENT = [
  {
    "id": 0,
    "name": "Electronics",
    "status": "not-fulfilled-yet",
    "can_apply": true,
  },
  {
    "id": 1,
    "name": "PCB Design",
    "status": "not-fulfilled-yet",
    "can_apply": false,
  },
  {
    "id": 2,
    "name": "Polymer Design",
    "status": "not-fulfilled-yet",
    "can_apply": false,
  },
  {
    "id": 3,
    "name": "3D Design",
    "status": "not-fulfilled-yet",
    "can_apply": true,
  },
];

var DATA_ACCOUNT_DETAILS = {
  "id": 0,
  "name": "Sunil",
  "description": "Skilled in various languages",
  "profile_url":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsWWIZ0ZbQUNgOOkXgV3IDzhkO1IlMlpRFuA&s",
  "skills": [
    {"skill": "JavaScript", "competency_level": 0.9},
    {"skill": "Python", "competency_level": 0.85},
    {"skill": "Java", "competency_level": 0.8},
    {"skill": "C++", "competency_level": 0.75},
    {"skill": "C#", "competency_level": 0.7},
    {"skill": "Ruby", "competency_level": 0.6},
    {"skill": "Go", "competency_level": 0.65},
    {"skill": "Swift", "competency_level": 0.55}
  ],
  "achievements": [
    {
      "title": "Top Coder Award 2023",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRHnGxrPPrT2b9YeotxxENQQ28GNqXvmBOqA&s"
    },
    {
      "title": "Open Source Contributor",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb8b3uY2VQ1rppjXUlDNBXQo_yLNl7gouWxA&s"
    },
    {
      "title": "Best Developer Conference Speaker",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsfI4glYBSceITyORne4O505jJ62h_OHV7lw&s"
    },
    {
      "title": "Hackathon Winner 2024",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTv1C0J45TxrJFLQfdZ2dePeZpo8LvFHlZSQ&s"
    },
    {
      "title": "Certified Cloud Architect",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-mWSocr5glrUBbO2T8qFfGvTLuX-EQpYc2A&s"
    }
  ]
};
