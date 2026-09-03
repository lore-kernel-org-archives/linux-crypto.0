Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296AC3FF1A9
	for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2026 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788419727; cv=pass; b=Bb5WgQChE7RYW76kMZasmuBqNcXx70XZi0CR3H/Yz1uh1GSy6rEP0C1039Hk0BXNmNSUAHaSQOKY6x6MWhTVqrpspN4zAPS5mRbzjaGR4MAEb88Tk8UdMW+NKfzRGbrjDADZAe0l2M7I2Crcb9WJzEz045zbQHXetUqqQQONK+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788419727; c=relaxed/simple;
	bh=BDxUrAidUvmdE4UU9/YWqxyp9t94nH6PJ+zSqrwq3lY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+77Y3lGeYtPhJQ4sXJQXsq+OV96vxOf2pOR6wy1Kd9uiwK93q6zw9Qx8ZWfRHvm0of9Rqh0mdppPZ8GU5e8l5vV3JWDnEJFyGRV2ivZOSj1ZLxDDTv3Rwgb4Ym2deBhU8TlQzjv32H7ntwZvPbwtP5TOoxQzLnrgsFHfqdBAlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=pzybxd40; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="pzybxd40"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52d7a3defe8so20741121cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2026 00:15:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788419718; cv=none;
        d=google.com; s=arc-20260327;
        b=sXKFc8jztLR548jz4VOFkK/9sQ3xRVzmq4ZvXj1HIcR/pBcBVBbrirYmc/PozSUy5A
         X43uZHS0NJWndB3NyB3790JRLNk+8W09rXSMbq/zladV5KhcMXmtDzj3yiu+PQ2wlIz3
         x8601VHB7289eSCdQrKx94bdVvD5LSLnJ39YmZOeSbAO7ivHx6d1AX23RHShKePgWTEa
         4I/78OtL6XyqsU20Tdm6i3U32M91zB2tE2v+aQZ0AfNrLcG6WwSpT6/Pea9rwEhk+0P+
         g83qSukyCrlDoaw2+MuQ/SuTbuSUly4RmSeRiyZ528wEReUWk7lOrGXGGiHprgmgcGmj
         UhrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/3ZaVDaa28jmLpu92uijSHs8QLly3pVgpirsXkJfs5Q=;
        fh=UGQhKhnsnboQPWep8CCTsVFFJkDVxULDxawogS+zv5c=;
        b=cebH0VPP1xHTqvssb3gEL96fKtE9bnUg6STSda+/RL3jNS2z+AJbGPyu4I1Cn31iS3
         uwT8hHuKb9I1qHW0k6iLlotI1rZY99nhDd7jSj+wd9K14z7FjWQDSpFt9gXZcsUERJ2V
         T/c0UKNr2ZeSs/PBEcL1woBGhD5eRzB+tF2Sfko+TXUzYDGFSdnpwzwTUtWT8k2vSTtj
         dCD3YL9ryBDkLdutQNT2eHK39Vdf1a8SRvbTP6Nj36yHomoFnpkeyOkFOif14HMOTaDk
         PZNKjNIiSPUGli/mzqGElFfHMe7xRxd2xAz/TCsEItQ0xm4Qhgztp23HFEoEtuKF77r7
         /jWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1788419718; x=1789024518; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/3ZaVDaa28jmLpu92uijSHs8QLly3pVgpirsXkJfs5Q=;
        b=pzybxd4057yCPXBfPDmQhjG7IRqXIMYi5LwPQaiYWrhpjRYbnC71NSqHTW0yLk6N2U
         LeHXabKfKRXA0CEQb3JuWOAjp69N48QhVCXkkT+vykwFjgD3F4ox4ami1hatx8UkxJZw
         gQOtiSo68ejMMfKhqyEDKC9YxEeXMFGtleuswKZ+pdRqUC0GtyvxPjqMeixIHfh4hmgV
         kwDZ2+RUgjgXE/BCSMl+guzCYHe5ANExTik3oSyseo1WhizIPmyLZl94oAODsRM+jQug
         Wp60Z+/PmQnbtaaTJE8iyy4DkoBOzZ6giL5q3oVKI12h/r0cZ6qPxXHrbydggsMeCFxk
         tl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788419718; x=1789024518;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/3ZaVDaa28jmLpu92uijSHs8QLly3pVgpirsXkJfs5Q=;
        b=eXB6LQ0DqRi+Bjitoje9G3/WBeE0S/84bHMWOaJWA0sA9NMGWO0/Q7nMpMwKeUcix+
         QaF7SKynJ5wguXMYGaw+rN0mWNkMhxmU2X+5aMcLfVbGHHcazOb/k0n4wqncyfWZZ8Lu
         EKHXNqh6WD8cwDTfYMnSRMO4jxf4mU4m1qgyp0cDgtKugBEvUMqjg8b0ClCPrsvhO/9o
         BTxNWT4u1tHmjrymQ748yle3wKiPYT5IgLraAkCPKn5p9DXm8WL24yrKg3U/jsLEavum
         5HdF1710etwReS3lBcCHKmR/KEBeDXD0WRIhPCaaQyZVpK0aoEjMc/eyr9qtXTtS8iMe
         B7Pw==
X-Forwarded-Encrypted: i=1; AKwUvBzibXaJM6dasUtbpOw7+wJrg7XodHntf7Vwm8igS2QyXByp42heog0zRx68kQcCVd0WOp59PWsyxisR07Y=@vger.kernel.org
X-Gm-Message-State: AFuF++lXKy5Mc4UVtsxt3L2E2/vpiEhM0EjiF+4EplkKnEv7XsgY2JAu
	pZ7sJ9z8XTZkPadycrtaHvapHbOsEGhtVhoRb9Un58hnGnoJBaxi3wPfCQzEi77jcVPFIXoe5Ue
	KvVFdMMWh9SEy1HNZP172EWaC+ulwyXq9YZqaAlAg2g==
X-Gm-Gg: AYBFou3pq3m+fq5DpC+loznf2jtzrZBRxzEqWH9ky2fTADyRe/JrxwjhpGj1X7RdUzS
	agBrGxxPknw28FoN6L6/OMV0fu8tesNdAuEtyA2mHNN4fsaxlUTmpnKadjp8oj3vfKidIVdfnOU
	ilWprxNO4D61xeANPbEVZHa0rDM0yiU2ryQ5dU8PHl0GEkNzaSfbxevjGacDlxJR5l3v5MysbTq
	9bfjzx5/z2qApBcfZkZxk+DUJciNueH87Fmu2DeSMsSdC4c1ufuAaQocAkowXXGD7YrCEYpMkx2
	2g55p8JNnlRw/GTYv3Z9sSavQbN8oN2G6gGTAM1NVPjSJTkHSYEbfc/oIW4s04/WGyhbIyins9g
	VI0w=
X-Received: by 2002:a05:622a:138f:b0:530:1e1a:fc70 with SMTP id
 d75a77b69052e-53036bc87b3mr104794101cf.1.1788419718250; Thu, 03 Sep 2026
 00:15:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807-acpi-char-v1-0-742c450254dd@thegoodpenguin.co.uk>
 <20260807-acpi-char-v1-1-742c450254dd@thegoodpenguin.co.uk> <60e25773-b3c6-4aae-a687-92e1ab3b141e@app.fastmail.com>
In-Reply-To: <60e25773-b3c6-4aae-a687-92e1ab3b141e@app.fastmail.com>
From: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Date: Thu, 3 Sep 2026 08:15:07 +0100
X-Gm-Features: AcwNN1WIqW6SG0lDemdV894_p4DFDolE7YAmpidzaCNJPpqblz3q1bAvW3wQFoY
Message-ID: <CAA6zWZJRpUzbz20daytHO4ygqKosM=YU8UyBcWnm2sUmaEHbnw@mail.gmail.com>
Subject: Re: [PATCH 1/4] char: use named initializers for acpi_device_id
To: Arnd Bergmann <arnd@arndb.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Mattia Dongili <malattia@linux.it>, Weili Qian <qianweili@huawei.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Corey Minyard <corey@minyard.net>, Peter Huewe <peterhuewe@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, 
	platform-driver-x86@vger.kernel.org, linux-crypto@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, linux-integrity@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I don't think this is the right approach: I see around 1500 instances
> of acpi_device_id data with plain initializers and only about 50
> with named ones.  Converting all of them seems like a lot of
> extra work, and I'm fairly sure you can just change the
> driver_data to an anonymous union without this.

Sorry for the late reply, I was away.

You can change it to an anonymous union and the kernel modules can
build and then you can go over the code and set the designator only
for all of the entries that will make use of the driver_data_ptr field
(which is the union's second named member). However, you will still
get -Wmissing-braces in your build log for all other initializer
entries that still rely on positioning and resolve to the first union
member by default (the kernel_ulong_t). Adding an exception for this
warning seems like a bad practice. On x86_64 all warnings are promoted
to an actual hard build error via the defconfig. The other option is
to use more brackets instead of designated initializers for the items
that resolve to the kernel_ulong_t but that would arguably make the
code worse, inconsistent, less readable and require the same amount of
churn. Therefore, converting the tables first and using designated
initializers everywhere to begin with, before adding the union - as
proposed here - is the most sane and clean way forward, at least in my
opinion. Perhaps I should add this extra explanation and information
to the cover letters. Unless you meant something else.
