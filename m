Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E6B12CDA2
	for <linux-crypto@vger.kernel.org>; Tue,  6 Feb 2024 12:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707221411; cv=none; b=CLD95XfM45czGmej4O7KTbZxc54Mt9I+weKDaFRAmBwMdy2CcVwh3j4CUiw1jp7Z/Ek09t4pTZoU44GyaX6g2wJBjrx9LJIQusYChU59c1Ga5sEoabfQg4GWzVo3453PZPzaVjAm6v/tlVl3T8q54Lq/ZrPeWv2RNW+ss6QLYKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707221411; c=relaxed/simple;
	bh=i4UWx+KB6k5rhBfd9xHyOK3WXVN5exrluwojnhLg4ag=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=EA4n2ZnPAmp2FSV/LDHeMFcV1BVqVUv+uwfxNMMuCLQbPDIzFPl2vpNPswprgq4MkxTvgjaLH96lzlWeL0mEb3tf8vc9BXo8Vg5ZEXf47D8//eaXXJe/73Hi3RuLMmtnEcFAzlBNqbG+HgmPPoQOE39M926iMPSO+tp3ISkVb64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cH3PW+gW; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cH3PW+gW"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3bba0ac2e88so284177b6e.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Feb 2024 04:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707221409; x=1707826209; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/KaQhFrp/zmRzqbdPjMI4mPbsvxaF4/4MawXckaGjzU=;
        b=cH3PW+gWcM39eFwfAhhUFsaY3BGHw/SEYGZmXSGl2MZW+l8jxcsRec+iaMOFyt0hz5
         L0R0NE/ZegT3tFo6GrkigXCccH1othnea900QdIEZX1zOkthmwMbh+HCsN/MRIWHY9Qb
         8GbSIWIAeZgQQyYXbcBGL0W5KTwz6+Lgvtpx6yGyfQLGdTfoi+jdsF16t0fmrT93yIqT
         Rhzsq3VIJ5JpGgU0i25ZaILUAaFDK3sMCdQYtuuziZl8ojj21ag3JTp3Wjm6KnvGyQSH
         NlZX6emfwDhI3YuwOWMUqsrQMGywxB6iGnURkViEcWuyK3JAzmUIsu3osGB9ac9dRwVS
         a/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707221409; x=1707826209;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/KaQhFrp/zmRzqbdPjMI4mPbsvxaF4/4MawXckaGjzU=;
        b=A7IDVUhSRIJ08pBZ4Yqdnbs/pjM50oiTMQlkMD7MbT2mNIFZpUuBH3rLnI+8NkA7Wy
         CbVSTdWhIDzaaT4jXrVG5BAem4fSkMi/3XKrpCm+nV3b2MICHqUyYdfOmEDlI6yrxsLw
         67/MyMJ6olqY0VH4feKI7zJiPHjHw0IPz5N+TAeSlW0d5h++Tuejzuw9JW2kPHM0alNN
         4oYV3Ho8Dym9bFkTA6tz694e8Y4LX3i/ZPCz2N+QmfgReozbOZHaAP5K4+U/fJEO3QO9
         G3LKNzlQWjsxJYe4X1hiXchv1V3h2+EALhY2vqaAAC7r6l4DAwNLwjnF437myQpOY51c
         FAyA==
X-Gm-Message-State: AOJu0YxtXTOJJI7yBVAe+V0aoqyTXaM7D/AqPtEBfvBOSCynlHBbzxOP
	mJOqmRBfUcGzqb4ibIuYnET5gpdw2XpV1XgrGbOdzhu5W5ssBDMTlzxMrTyWkY5gQEDs+4zCBBP
	ui4wXbDMRncnWmHDeZzJWa0ERboLqaWci7A==
X-Google-Smtp-Source: AGHT+IEkGDgkXq6vKCpEkng0hu2wELk4EAnD4yBM6NBeAP1m/fdEF3zCFVBfnlrzLM53Hp6zpaoGnL4yGDs2wAbPDE8=
X-Received: by 2002:a05:6808:bcc:b0:3bd:a00e:edf8 with SMTP id
 o12-20020a0568080bcc00b003bda00eedf8mr1221532oik.8.1707221409146; Tue, 06 Feb
 2024 04:10:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Jayalakshmi Manunath Bhat ," <bhat.jayalakshmi@gmail.com>
Date: Tue, 6 Feb 2024 17:38:40 +0530
Message-ID: <CALq8Rv+w+E=KZrOXJirtS7jzUWEeL++7k0W+RXe5yKAK7OpfHQ@mail.gmail.com>
Subject: Sub: USGV6 test v6LC.2.2.23- Processing Router Advertisement failure
 on version 5.10
To: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi All,

We are executing IPv6 Ready Core Protocols Test Specification for
Linux kernel 5.10.201 for USGv6 certification.
Under Test v6LC.2.2.23: Processing Router Advertisement with Route
Information Option (Host Only) , there are multiple tests from A to J
category. We are facing issues with test category F which is described
below.

Part F: PRF change in Route Information Option.

 Here is what is happening:
Router Advertisement sent from router A with PRF low.
Router Advertisement sent from router B with PRF medium.
Echo Request.
Echo Reply expected to be directed to router B. However, reply is sent
to router A
Router Advertisement sent from router A with PRF high.
Echo Request.
Echo Reply expected to be directed to router A. However,  reply is
sent to router B

We tried introducing delay in the test case between each request to
allow processing to complete. This did not help.
Has anyone observed this behavior? Is there a patch for this issue ?
Please suggest how to go about finding a solution for this failure.
If I need to post this to other linux network users forums as well,
please let me know.

Regards,
Jayalakshmi
