Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43F1110B
	for <linux-crypto@vger.kernel.org>; Thu, 28 Dec 2023 03:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3601c1b80d3so12242165ab.3
        for <linux-crypto@vger.kernel.org>; Wed, 27 Dec 2023 19:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703735884; x=1704340684;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BR8ESoASuU8V2RWc34DU7+3qPu93Hk6sdH8cG4pUQuE=;
        b=LapSkcTyV0TlzI5fdW0bEn/uwjGn7BsbZSmiU1k9Nl7krb3SFTvaNjgYLzFcyWj+SX
         wR6/k03wKd+18WAXFSiMqqR1OPByh1FMbOT9+1asQxSDO+pkettPd2MailfLuFqTfGtG
         nUQVD68nMHhU/XZ9Ab/q62yQZLa3Em9yd+n7bfJVCj5agNU1+eFLzCHFfaOgxyqVsOw6
         cn0V+0JU3EDqHFxgrprY4dskOWlgALuCQ/m1Giu+E5ciBqapXv7C6mTRjS2us98Ut9Az
         fGRGYXJiwq5xG9jP+x5GFi3eODagfNi/8JhQ5IF+vWxhes4AqwGfgGPBG/XnjhQTb5wJ
         TzUA==
X-Gm-Message-State: AOJu0Yyvv81aWcsZg/g1Pe8ueooNpci5Sbh1JpI5EEhcpJdgfwhMbw9p
	VfqXZF+LUWAMv3uIschQiEpOzDjZ2aQownLhwzbdxmX8ivAW
X-Google-Smtp-Source: AGHT+IEP0QvhbaZW3pduNGj5tGoAXor/EUbCFTykclDEmBcqVr+ckbo0XgxqPTMmuEtoUl2/HrHAlRLEShi2mqTFslyL0khjgl+G
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1568:b0:35f:d9cc:1c9b with SMTP id
 k8-20020a056e02156800b0035fd9cc1c9bmr1701210ilu.0.1703735884090; Wed, 27 Dec
 2023 19:58:04 -0800 (PST)
Date: Wed, 27 Dec 2023 19:58:04 -0800
In-Reply-To: <59815d0e-2f44-408e-a81d-989df3323f72@bytedance.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029978d060d89ec2e@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in
 scatterwalk_copychunks (5)
From: syzbot <syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chrisl@kernel.org, davem@davemloft.net, 
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	syzkaller-bugs@googlegroups.com, yosryahmed@google.com, 
	zhouchengming@bytedance.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com

Tested on:

commit:         39676dfe Add linux-next specific files for 20231222
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=104d06d9e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f3761490b734dc96
dashboard link: https://syzkaller.appspot.com/bug?extid=3eff5e51bf1db122a16e
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13756fe9e80000

Note: testing is done by a robot and is best-effort only.
