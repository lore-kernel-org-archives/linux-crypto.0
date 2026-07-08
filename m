Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29572377EC5
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 09:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783504696; cv=none; b=rHlJ4I9PBL9zw9mJGKHaj3vXP8x1EzxAXeYswEVZSlngWcxqlVa428GeuvuOl9B5BX0Jgr2zZGOqThiEtP+mfgMngvVck5j/WCIkS2vguphcoilW7nbuvydAea5fT84bRiybrf2yk06xI7QDIIxXR9iQz/RohRr6C4pWOCGRuws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783504696; c=relaxed/simple;
	bh=ZPZ8Ghpofvj3SxI2tuKyXiYtS79lSc4K8bhJ3ppreTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbzmslQ4TokpJooP1wkjDHFSgs5c/iLLWshB7rkS2iGtuFvprtRawaLq3G56ssjNbaNSoA4UPUCyuLsiKs3FI8YoMS8wFnZ3Xeg01mHhz/FLx/l+fW6njU9AoJzh9rrXL3JFOv1A+g6mSx0pLcgdCtstwlN+poF5YQrY828j9O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILtFqY7U; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LAhN7SFy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILtFqY7U";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAhN7SFy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783504694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZPaMybjeMNKNpD8AtX/8HSMSCIwjQpAmfLjC6sDrjw=;
	b=ILtFqY7UJqBByRMnDExi1pAuF6QnUw6I40kfvbNYvBG1NZvlTsLwiv5b+yhSF06kEqqgad
	aEW4M61P44rFj2He2Y1Seut75zsVI4iBnz7O28OoRnFQOb4NHzZpQl9nFIofoiICyK/qhF
	7gEhuVObVbtZjx87Ybh1N5ftWLWMBcc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-u3nG_Lh-ORyhs4L78_FaGQ-1; Wed, 08 Jul 2026 05:58:11 -0400
X-MC-Unique: u3nG_Lh-ORyhs4L78_FaGQ-1
X-Mimecast-MFC-AGG-ID: u3nG_Lh-ORyhs4L78_FaGQ_1783504690
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-493c1bc7a70so4452515e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 02:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783504690; x=1784109490; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZPaMybjeMNKNpD8AtX/8HSMSCIwjQpAmfLjC6sDrjw=;
        b=LAhN7SFyMNxgdC3eCNsZJ7NpwILQH0VQ7ps9BlsMbNl6xyYsdYyzFSy0Ks02AH0GHM
         p3yJ0yAhwKENfKrljwmppPUb6so8K3v28GXtIN40ZPu0Ng7QosIqkN5dkKWI9y+xrsNt
         u3KB0K1GTQVyjIFt7J8neEdh8hPWENDJQ/s74WI+cF6DIY37X61Tv/n1KV9OxnewjYr4
         u8v63Lcbo6etOIpsWymXhhYfEvh+LKYp7qzghPkxXcVeb56l40bPXPpmkwwZun/8SPcV
         qcQ3q4cMglE+rytPdjxAjOi0/a9ytzB22pddRqiMeRqnhrPO1lzufCm7F9Twf1BQLd0X
         q59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783504690; x=1784109490;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZPaMybjeMNKNpD8AtX/8HSMSCIwjQpAmfLjC6sDrjw=;
        b=ApZVd0uez885zYml58t0LD+M8TgZd0wByMyDLE/i0/0RFpsFvg3JlJEZjyMFSps3BN
         c492Jo6g7RK+oRDpdmx7xJoY+CjBCTHMi30reKHEVG3uu7+DUfR/C+nMkn5eTgdCnF9r
         eoH2t64Xu9y5AtMyeUpdXRSLkaMn8ellKcKLSJUIC8mAaS9vyOTzWT20qFCMpjiKs6hp
         /dmKj66NLNDxoXNYsyf75576inedkcfM0AmsWmga9p6AL8sEawKU3P/1joyJFNbt2vzM
         KUpoWptokVqPY37ZCx+Hm+ZCXiQIP8oelh+hL7NxzEPd3CzO1DZQuBnZxZUVM5oL9zXZ
         JK4g==
X-Forwarded-Encrypted: i=1; AHgh+RpcVhsW72/Cz7wYlUDd/q4UXtDbUck7DyZnQXMHzNLFdCf8sixvNGRUc0bc4mkYR0Mm9os/xadhkXT3SHs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8MnFEV4bjtygaAubzm82168srDzvJ+Y5khOeAhPk1GCH8MjwL
	GDs5ZNGoPa0DXo3pWhErECtj3mdxRoNMD171wPBfo+d6Z6R7KMpvirg/tPYmgAIJUD++s7X/prk
	vufsqU5VvWI2bbXZF2eQXeEJQd62hgZTxt6aIvqJnlDgbyd3X+SVM+mxqgi/GiIeH9g==
X-Gm-Gg: AfdE7cnLZQEDVqeoAaNTGOgIpPeD4urpH+GI/P7j+rpc43pMTlFyQ9dnWCQ5jcoedyx
	/alejadwbdoEcOaIoJ0WL6p86vkeblQtzs/wmYxJoNSxUgXJBydLDW7OaMsmzAuXJJiizFd/9OE
	Z64Y8HLi2oecHn77waVn37Z/H22WZDDgGWMN6VTb/Egu6CxVzyawlEblFB2DjW86Ci3rzJugA/H
	u41+0/f/JFaeSksCSXsUiD6n4chCpQt3AcAUXgsd+Mzw/kXKU+tpNFf2ctmlG5MFEyDsOJDTkZL
	P2yP5S8u7xfTRULD6Z1WAmM4XFJo9CLiVioEPb/S/AqYuhtzol9M4mqjt6mebkcI8IX79ym72T/
	FUDK7z6HwVCYqVjZRUBDmZWLXwcsJ0wrhUqWkapF+5SnFNxRZP3icY+z509YfslIdhBJA8gYaV9
	hokntEqJocYKym
X-Received: by 2002:a05:600c:3e11:b0:493:df1d:7488 with SMTP id 5b1f17b1804b1-493e6904b5dmr20334485e9.16.1783504689795;
        Wed, 08 Jul 2026 02:58:09 -0700 (PDT)
X-Received: by 2002:a05:600c:3e11:b0:493:df1d:7488 with SMTP id 5b1f17b1804b1-493e6904b5dmr20334145e9.16.1783504689342;
        Wed, 08 Jul 2026 02:58:09 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fccf2dsm135091445e9.15.2026.07.08.02.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 02:58:08 -0700 (PDT)
Message-ID: <e981a64f-ec3f-45d6-b20f-e03b61a91f2b@redhat.com>
Date: Wed, 8 Jul 2026 11:58:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] VEGA: a syzbot-like workflow for LLM-found kernel bugs
To: Yuan Tan <yuantan098@gmail.com>, linux-kernel@vger.kernel.org,
 workflows@vger.kernel.org
Cc: jhs@mojatatu.com, gregkh@linuxfoundation.org, sven@narfation.org,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
References: <20260708092247.4188498-1-yuantan098@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260708092247.4188498-1-yuantan098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/8/26 11:22 AM, Yuan Tan wrote:
> The rough idea
> ==============
> 
> VEGA would have a public dashboard, similar to syzbot, and would
> send selected bug reports to the relevant kernel mailing lists.
> 
> The goal is to send reports that contain enough information for maintainers
> or other developers to pick up, understand, reproduce and fix the issue.
> 
> For each public report, we expect to include:
> 
>   - a description of the bug
>   - the tested kernel tree and commit
>   - the kernel config and environment
>   - the crash log
>   - a minimized user-space reproducer
>   - the suspected introducing commit
>   - a suggested fix patch
> 
> The suggested fix patch is meant to reduce maintainer burden. It still need
> human review, but hopefully it can save a lot time from building a patch
> from scratch.

Thanks for sharing. This sounds very interesting to me, modulo final
impact on the ML - overall load is severely increased since the LLM era,
while the maintainers pool not so much.

A few notes on top of my head:
- the amount/rate of reports is critical. The higher the rate, the
better need to be the reproducer and the suggested patch.
- the crash log should include the decoded stack trace.
- IIRC syzbot reports sharing is [always] human
moderated/limited/controlled. I think that is the correct default and I
hope it should be possible for you, too.
- it's not entirely clear to me who exactly is 'you' and would
appreciate more info about that.
- it would be great to discuss this topic in person, i.e. in the
upcoming NetDev.

Thanks,

Paolo

