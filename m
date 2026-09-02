Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCE94AA02A
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366896; cv=pass; b=KGOUqHgLi3qxFsJlHuSF9YWW35i4bkKvaYm7Bs4X4WqhqYpY5tAOQUfeXiPDYm8melViFgr7Hk2zno9N8kmj5nE8+t64QdxED9j2lHMzO1LQiXLFYXLIhPyb4xGargVw844O1sF6OQBUoQrcis99ZuXJGIDewMnjENsKePPKiDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366896; c=relaxed/simple;
	bh=BfEmlkBKcWe2ccNduTBti/ySDv9Dy75blbe5/+Ct4XU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qJbMRAJVASvU47BwcBGSDUBRhYIggqeu2o/TGPldVwgfGUPzRMh33iroxucVL38YsgW/yIiUY/CHDjMg/kkJ86B6MjLTQtWWSEqdRj9ia1hspyEgF7bJmii6/IQ3UEYWFLCB2wXde/9gu0EYUGUuHQCcMp2vrC+rQOlP4OMbHlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cy8rpqnI; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cy8rpqnI"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6b1b1cb72d0so525392eaf.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 09:34:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788366893; cv=none;
        d=google.com; s=arc-20260327;
        b=EvS2zHO1UAE1cduIaIcftV7CYqRlQFJPrKxNO9z1+WWZWGaGOF4Z3rjWYuZ3GjKip8
         NLKKFBxt8Kx+H/IL5XmM1TmlA1T7101PQ5vzIV0iuo6X+lvh98ZXktYjn7RO6upyyMwT
         EmerkKIadn52W+E3tjtnII14DN7X3+riPAU6cbSXSQCG75RrCmzWgUriunnejsPMZscE
         9Hf3csLqRIJWJUzk5iSFgqTCZrk/IRouYh4ebdCqtNChpYL4eI3AXfaoghWuZUI4s3iI
         7oU0Z2BgQe7GovzL9UXGhJ7IdH9eL7GOCIg/5tqkXnFJU4PC23wCHtg60vLVhsAj8xsw
         JMzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=US9Ylb+9AiTeXprRTRZTmUqpRaQkuKyTcR67E8oUP7U=;
        fh=w7iShSf7V+UfNeEPUEYqM2w9OmC9GcSwlOQOS4NXlz8=;
        b=IgfFTQBBtDue6hIJ5FmfIsvwCYhMtJDKIqXfUTQqz8EgitEgF3ZboV+IxFTdNKCpTo
         gpohzkK+gNW4Gg1VqRwLqDN82HQ9vtyaOCPdsM+Io+XOmG3WEFqqSrFtTWlDfyx59PNy
         hIVE529W8651FuNbnhaNiayOL0UVAGMA4lTszM7LeMT3QcBGPRSFj8YebX5zvL3Y3ABP
         zM+x1nIijHkVmBg4V45RTu/KznlIRmY5u9bf8ALHiZU9M9mVUL5AvFBPK8vDIP05if0e
         bkBIQfKJ1KwUuEsCmVUOUGOFCuxf21vMcBULOIa7QW55MF4XxHP9GTmOr/hpEvSsXsdj
         pVFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788366893; x=1788971693; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=US9Ylb+9AiTeXprRTRZTmUqpRaQkuKyTcR67E8oUP7U=;
        b=cy8rpqnIQ+2VJ4lINHfL74L8S9OhYhckBddCBaqsdhpu/+kTlXr66den4h5ZiYrqRK
         O3XzW5PpGUVUyWFyfZsMM/RJSCfGY9lQYqGfmPK/DSlWng1bvgd/BHYokxfippxaP1Xs
         KL7HwhjyX/MXM06hhaP8AZ+355XS/jiwX3O2/T/ZzENfb/wIfsxUqD8IB4ysOhfXkipM
         8sIXG415I79dE5eeoR05szl6VbYlm/cmHyribtNuQIQqh8ZoDWDzn6RSr/6554v3qkuV
         J2mi6c3jSFIJtrV2qf6HI9Q8Pe/2qNl14r4Pu70ISL3ZVjIKLe0z0uO7Fbx6YTQxy1W5
         iQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788366893; x=1788971693;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=US9Ylb+9AiTeXprRTRZTmUqpRaQkuKyTcR67E8oUP7U=;
        b=GUMIKUsf2XJtkyEo6bWEJFS/ktA7ivy2BZqI88QiboDGWNTv+MBKcOl6txv7XsTr5z
         oymxqw6NRrMoHKNPqBZRr9aTDFUWQKzdPnY8ucQsZFpZ04nbcc30XmCEmfH6VhGsbpcs
         +rP9x+DCXQjObqAl792NbPHsHAQ+EmAVXnvp3Y692aJFesJMxK+GRR37x3CJAXapG5ua
         +R+Gx/PvuDZwkEUnKRPEwszjVrNYKiPQwukhoI+i1AcngfZjv7nhUbBLe4SOYD+v7cZL
         bkogjkqu4U3RNh1kzQ+HLhBG5e2OFGyPP8QMSDeMLZcY0FlP3fC3LQelCqp0B47iZ9xl
         +48g==
X-Forwarded-Encrypted: i=1; AHgh+RpWayzk6S0ZFMu4abnbXHS2oBXxei8BcclAoJfoAjsn2J7O1nBUbtdGcIqRYHmeQGhibwm3jW3tZnzaTCE=@vger.kernel.org
X-Gm-Message-State: AFuF++mpBZZJANqRCWE3oQffWxMnWSlU2OiJfnetHBgT90JAGlBkiXBg
	QFwzB6EfqgD6q5RWrIyLveUE9kdkAmQEl6XynCqEesIhC+4MjzKve//OyluHEHmJYJmQ0n2Aakx
	jsSaW/wuXHc39bhXVKoWTtVbLA7nCI/w=
X-Gm-Gg: AR+sD10v3fcPXdkXDBgv4m+c9te18UHrG8SwLbCOFnGRULhFtiSmEy1jGR6tlqvwXxn
	oldd50kwJvf6Ej764khDZ3XBp613AreTZL0oTbLo/0ssaFHbSM+jpczxouJ0d6nNViMFq2QIyC6
	hpcpcE6Y4KQ60srVyssjRemOoB7u7Oh1VVQey4P40M6DKmHeH8TSJ4Ctn7OTzHmHzTnzJ9eteff
	XwyG0dCnkvU3XBOiGgVZw4jLaRzX0TFxbeEFgKWhH2Dmy5JW8DO6N9dF4dczTrJRY2s3LsRTAPV
	lvYlolQ+/w24DsohttPGzWdXZ8oNzWFD9ZePRxm31ltTFOj772/3KAr91SAYvPS+Z4+4oq8+yNr
	yuvmJW7ocSLW+u2Eysj9luaScFcR0H6XIt7R8NOBgZSjap09V+bSagGG8az9fU/Uu7OHzTdthx9
	Oc8Dm41QdEJjiShr2Cmg4FZSB5hsEqZuTRQj9n+lje
X-Received: by 2002:a05:6820:16a9:b0:6b1:445d:aaf9 with SMTP id
 006d021491bc7-6b47d4cd775mr4034068eaf.8.1788366893040; Wed, 02 Sep 2026
 09:34:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Andrew Wilson <wizlonex@gmail.com>
Date: Wed, 2 Sep 2026 12:34:41 -0400
X-Gm-Features: AcwNN1WhXm-Lt1F0X-OQuMqxjgk1a3bMvVoyZLhgjbgALurTS0LPjsCCof-Lok4
Message-ID: <CALAyJWrn7OQyQMd5OPoifn_3qe6iWNf1+xSSg_six-+po9kpvQ@mail.gmail.com>
Subject: [REGRESSION] [6.12.y] crypto: ccp - Move SEV/SNP Platform
 initialization to KVM breaks SEV-ES VM launch
To: ashish.kalra@amd.com, seanjc@google.com, aik@amd.com, 
	herbert@gondor.apana.org.au
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
	thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	1145026@bugs.debian.org
Content-Type: text/plain; charset="UTF-8"

#regzbot introduced: 3f8f0133a5fc9b32d0c308530320c3f2430ba5ab

Hi all,

I am writing to report a regression affecting AMD SEV-ES VM launches
on the 6.12 stable branch (first noticed in 6.12.97+ / 6.12.101).

I completed a git bisect between working and failing kernels, which pointed to:

Commit: bb1c84647025 ("crypto: ccp - Move SEV/SNP Platform
initialization to KVM")
Upstream commit: 3f8f0133a5fc9b32d0c308530320c3f2430ba5ab

### Bisect & Verification Details:
* Last Known Working: 8a599f4f74d4
* First Broken Commit: bb1c84647025
* Tested on 6.12.101: Cleanly reverting bb1c84647025 immediately
resolves the issue and allows SEV-ES guests to boot normally.

### Failure Description:
With commit bb1c84647025 applied, `sev_platform_init(&args)` is
removed from `sev_pci_init()`, assuming KVM handles on-demand
initialization.

On bare metal, the PSP firmware appears to remain uninitialized (does
not reach SEV_STATE_INIT at probe time). When QEMU initializes KVM and
queries host SEV-ES capabilities, the ioctl fails with -EPERM:

  qemu-system-x86_64: -accel kvm: sev_common_kvm_init: guest policy
requires SEV-ES, but host SEV-ES support unavailable
  qemu-system-x86_64: -accel kvm: failed to initialize kvm: Operation
not permitted

### Hardware & Environment:
* Tested on: AMD EPYC (Rome / Milan) Supermicro platforms
* Kernel: Linux 6.12.101
* Hypervisor: QEMU / KVM

I have access to Naples, Rome, and Milan test hardware and am happy to
test any patches, provide dmesg traces, or assist with debugging.  I
am not a tech-expert of any kind, but I have time to do some testing
if it helps.  THANK YOU for the great work.

Original Debian bug reference:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1145026

Thanks,
Andrew Wilson
