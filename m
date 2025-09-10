Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D125C31D364
	for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 06:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757486129; cv=none; b=Go48ISPK5N+Gi2NGhqie4uB3YYJZggy7SC2CrXcfPrzvrKWf3bRZasHJlqaWxnMgR2TAmv4g8ZeuNXwbmF7pUxTSUKt411aoxfF4vi2F7E+qQAUF75GcSPUwfMolLxrgfdzq43hywP0nCgWMcx3+ljgB7Gk9KRxbAYcBBTdN0iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757486129; c=relaxed/simple;
	bh=bQ+w15MTl9RN5jFUVU3nhNkvtLfWTqdQsXWM9m/f5g8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j1POPi3OPYyJZeDxcxGB9+8CcQgxFVmgCqyIzP5gMEjCzhOlvlRWEgYNZ+K7HhgtNI/OXNsQd/eOYu/tL93/3IehVCzvoyK+QrePm+Qa5xM/g6x57Rw/rvD9+M4udMTljIldnJ5pwfnixA2t/0uomqc/iFhovzDwyLsObJjQqkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rfv3slul; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rfv3slul"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757486126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1/tuWACW+YE3IQwtK7wyAuuhZean9mhQqCKf9VrtU6k=;
	b=Rfv3slulyQXBUDkG1ycIGdK3Lp3MEkHB9Yba/91SifeAZc9HaUQwbXTnCq9Ky64TBX6XK3
	BWwCLLjpR1aFL7sFHZLIzGranWvg6Szudr1QMGCRdaVCp+rqVwgVt1C3DhtMl8MRlOS06/
	Ye/Lr0OdJdo68Re/ozwr8sNJLHc44hA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-xwD_GDDoMOalBA-30sqO7Q-1; Wed, 10 Sep 2025 02:35:23 -0400
X-MC-Unique: xwD_GDDoMOalBA-30sqO7Q-1
X-Mimecast-MFC-AGG-ID: xwD_GDDoMOalBA-30sqO7Q_1757486122
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e26569a11aso3161446f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Sep 2025 23:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757486122; x=1758090922;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/tuWACW+YE3IQwtK7wyAuuhZean9mhQqCKf9VrtU6k=;
        b=DgnYGl7/xR/1Fa1mKPLvZUqNRqFXii/yDrsBkDdgetdu7nn7Uzs0hMA9XQmmxRMoxF
         9Ze4LRhCgeOLgc/c+NkZGQqsOy4TBiq8Z5IhlYUI8keGt7c3x2PYXC3RGq1GvmhM50zp
         55ERH8RA4jt9t3k4Xly3SOLHIq1OJ4wRHqQc0KnN6xgXivxBlXeCmn7G8+l7QECWtEsK
         dnqSHlBsmg2OcKfWlNjf0NAINLc8dfRJYqk178ZWtlRNp4OWpu6y0rkLUamzqbPGvn0C
         hPo9PSN7S+4v4OWexaa0JxWFwWGl6rYFElIFtaHjvAc/eWcdASRLSaoJ5ftsQu1xZyhk
         d5iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVj8waZHfpPnl9Bku6KtrqYLnZ1pWNDGxQjcILo3IZxovqp/307+OaBF4mRNOs5ksO1PMqNI2cD887Xdhc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Grxxn56qYkegieKh8szV1fz5LJ9Xd3lBsn8jvJelonxVRR/t
	cZ59NKh0WEOVrORdfrU317fXbkcA5qX1T4G2gk5gqim2CELCf7sAn5EBC1k4xYvKIzMGTMnOWB4
	g4wLjAYXHWi+vmXUGHy7E3eTTmHHep4YB5UkCCT+4IgYaWAHQLdK6nYhNeFZpmz9kiA==
X-Gm-Gg: ASbGncvD87TD4pY2TyKJHiHUeZh1/Bz7Vs/GOopuPLlXflLTtUQB+vnlOuZUh5yuXOn
	nPwqbbTHBe2sMYn3U/D/BuHPEZZtDOcV7ztWl6HEzF8Ai2bq4buY+da5FH8wWkScYWLyL8YJSdJ
	V554TJXPNdnNMcUf1dXAc1PBZaVNm37FONx6FmkdwNhyZ6sKELC7kPm/ohSscKbEmBxAROrLlAJ
	CWjCWhGcgS20VEy1LY6830IgGxY56yLjq0DjIYYzFLAMd642IMuUUZPU9tybqgSRF5/lrg1PQNs
	MCU+aodIekHkf6OfEZVNN/a8Zc29+ru7eWZ0d8q82+9KkQAozv+yX+H3cOD21n7eQQoeBAszNKK
	nsEo28Ut6rThDjifNQITNJ4jmMrhASPZbrHRA5MUErJlD3rQ5yijOcQYyif1HGiRAFvk=
X-Received: by 2002:a05:6000:420f:b0:3de:8806:ed17 with SMTP id ffacd0b85a97d-3e64211e36bmr15711704f8f.25.1757486121988;
        Tue, 09 Sep 2025 23:35:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1CLbthnqMg0JojmsnCmMzIo0FEhwz8DHkvvjIQ85wqRnbvrk5Vvm6brGu3SKd0Vt6WZPpqQ==
X-Received: by 2002:a05:6000:420f:b0:3de:8806:ed17 with SMTP id ffacd0b85a97d-3e64211e36bmr15711680f8f.25.1757486121523;
        Tue, 09 Sep 2025 23:35:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bfd08sm5429110f8f.4.2025.09.09.23.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 23:35:20 -0700 (PDT)
Message-ID: <26a9495a-cee7-4db8-895c-aeb0f1784989@redhat.com>
Date: Wed, 10 Sep 2025 08:35:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [crypto?] KASAN: wild-memory-access Read in
 crypto_nhpoly1305_update_helper
To: syzbot <syzbot+634e67b3f57206befe3c@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au,
 jgg@ziepe.ca, jhubbard@nvidia.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <68c0f496.050a0220.3c6139.0017.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68c0f496.050a0220.3c6139.0017.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.09.25 05:46, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    be5d4872e528 Add linux-next specific files for 20250905

^ old tag

> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10f70962580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a726684450a7d788
> dashboard link: https://syzkaller.appspot.com/bug?extid=634e67b3f57206befe3c
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1247a962580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12751134580000
> 

#syz dup: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register


-- 
Cheers

David / dhildenb

