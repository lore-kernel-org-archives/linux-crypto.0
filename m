Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8611C701B
	for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 22:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739916304; cv=none; b=fljOLO8cbwZyHKnMQCWf26ZASs2bh7YB+/1xzoeo6FJ7c3e+GRsB5VoVn1RIQXC9V1tH41BUnPB/Q8xIs41mWprzgor9mpXO6776gzfIhAoQT3KpGQo4SAHVWeY77dt9PaCFtx7UyxMf0CEGhjNBC6kkRByS46ZaW/GhDPQeZ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739916304; c=relaxed/simple;
	bh=YAwz6c0pD7kSaVjGnc4vj0FlpUoq5ws50vP1ezS0ePU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jOpO/tDhSUD5h95TFGLC3xK0QZ97OA8wDlBMjymNfX1FOE/eiv82G8pHTphZf6YmuW89+yOpa5C5w6RgzScM/5Jd9redjl/jjU4Cor4Wwcw5g455zLEulw62LdvaVwhN8mHdYwxVTTUJH1ScFjM2EDh+DYPh3ve9yyxNjsDmYHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d18fbafa4dso37385335ab.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 14:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739916302; x=1740521102;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FImqr+4BueBo0iUqhlEc55Y3VSXeJLj+aXSM8e+ulyE=;
        b=Y6uCtXRp6Y7pssZ8xnSE7KwcJSOx3FjI2+naRgNXnITcTzLHt/o0UuzF6L7hEP5vN1
         NWbOco78qsooazmRt2wuaY9aVR6WJ8Qch5OohNMeYPym3XWWMSt5prjO4TaZLbDsSu38
         +V+nQemcKvh1lmmGTsf14CwyNyeQRF4kEqpqWdC9SQTJ2vNoGfVVa8YyG4f5aWZrbq6t
         iErHv4tWFVkq/1C7zTLMXElDG0CuhT9sfNnwHbM1JUC860GHjbUNho3VJEekgSfFOCUl
         vRWSiclEPWh/TQ2U2azUhE3qgIVIkjVzqylwg0wOJumaLSDwJlN+zHNUCRo++hAZ5Mpn
         KHcw==
X-Forwarded-Encrypted: i=1; AJvYcCXqUt+ocVpYg+n6esz0GI9Ce9JgMTFH8s650rSjJ4eNKplEJO/lyMKv/Tm7iqGkXQtBNaeWL+zT0Rikq5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO4zhIvhyOJL19or3G6CxRMXZvM1RYYABz3SR51ZjvEqS7oi49
	UbU0H7vrjtT+uuzj2TfOK3SWM8ctV7J8qtCIWOAMuu6N1cOVijkGji/5YKA+IOeHtNidIVPoiDd
	nXcY2qOTFQfNtsZaCz0nflylHfbCfoNKxSdYjt8tHI6+vG6NRTey7rvE=
X-Google-Smtp-Source: AGHT+IHFkQCkf7a+SjYszpFggOY908K7AMaQySeg4oPtXYgEqe6lCPeS8BsNAK7kIVcqDKND1GHr9KFAOVOrC1/lZzFlrhnkRlkU
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1689:b0:3d0:4eaa:e480 with SMTP id
 e9e14a558f8ab-3d280763d29mr156645915ab.3.1739916302497; Tue, 18 Feb 2025
 14:05:02 -0800 (PST)
Date: Tue, 18 Feb 2025 14:05:02 -0800
In-Reply-To: <67b2eaf8.050a0220.173698.0020.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b5040e.050a0220.14d86d.0013.GAE@google.com>
Subject: Re: [syzbot] [bcachefs] KASAN: use-after-free Read in crypto_poly1305_update
From: syzbot <syzbot+d587b24799bd8c2d32f4@syzkaller.appspotmail.com>
To: bfoster@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	davem@davemloft.net, herbert@gondor.apana.org.au, hpa@zytor.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a303a4580000
start commit:   2408a807bfc3 Merge tag 'vfs-6.14-rc4.fixes' of git://git.k..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a303a4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a303a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cc40dfe827ffb85
dashboard link: https://syzkaller.appspot.com/bug?extid=d587b24799bd8c2d32f4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c4f2e4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e4c498580000

Reported-by: syzbot+d587b24799bd8c2d32f4@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
