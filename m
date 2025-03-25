Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B021FFC4F
	for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2025 20:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742934204; cv=none; b=M20DwLajcFVwz6l3TUJqAiZNty4YuqWBGkTiGDyV5jukz/Dvu908hiHreCBYxVZiBSY0vD3rUNAxaqQIx7dyXuDpHNYQuBuFKwNi6sbXGyrUehfID9usgNhZy8ErEOtN5nqNFj3siNSiMrfr+SR4CTMQ8SsIz143XEsqNMNv5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742934204; c=relaxed/simple;
	bh=ogqybZep0WpZHhJtz+jCutY9Y5w0gsZQNbwghBWP/kU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ahA8CQp5nIdoXhPyGrDgi+wKapwFg25gyU4H7YdrNliFWFqucfL4QkJcfvqr3Lokt/bsyJhhj+4gTc7+Ai/3Ld6LOpzkv0XrHLCuRZHiBF6/D+Dj1emEEEgLJPVZImLc90p5xPMmjlPpMAYq6+X1aXdyULvI8JRh72SiUMvujLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=p7+gXmGZ; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="p7+gXmGZ"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30c461a45f8so59778361fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2025 13:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1742934201; x=1743539001; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7pKjJ2eC+e0PybVh41up22kgdJeIh8izK8jO6PVSqDI=;
        b=p7+gXmGZmPDkCrZxrOAm9Oea6X9IZtg7uQnj9mo+9wFgllTAucYp71MAQXS2JqGfii
         +YnahwOvX3gmgRwecY+et8wk3fLpYBA1Tzs2pNkxdqdmX4eXHnE6OUk4YymKCA1dc7E3
         xel03q5hW1wLJiqq9uJPAqx0/TFVZWWsXc4noJicS5ID82Wb+dNNTQQE9oSLq7cSdhaG
         lcNaEosl6YbF23GY33u9eaNvp4WEcEXm/HBn9+jxOb7PupBQ1EFIufKk6LIU1q1KFR6d
         I3PNYfbjyifsVnPABh4y1Ow16ILkHOj85r2EQVcmeKBkQSovPRSJ27r5N4BBE7P2epCG
         5aCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742934201; x=1743539001;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7pKjJ2eC+e0PybVh41up22kgdJeIh8izK8jO6PVSqDI=;
        b=FyaEjT98k43Bb1zIf6nmuX8UHVkwARaYPQnr4EZFFat6wM5ehSwAHfAkRhf6sd/r4I
         6tWGsUZQNstuwNRg583pPz+v6QSmLhSG7bJXvH9RmLcg8JhbU2+pBDx0o2DDXrJ6hX9F
         R860dceDTa5Pi6O20JkqwxtxRTvZpvTRrRvIVw8fMXLhL8XccJy+U8oGpEFpCHOCiK/p
         StVukC1erxog52zcTQvidV2vogE7r4jrZTfFSR3rRJN3feieOhZzBfrWlC8ZMFtPqSyT
         FEcHzGAI5y2kSWPeQ0YoVjeb/YXfGYsCihzdW064hfOxi4ACxqi6MUCcH9MxmQ3mmXhv
         9EUQ==
X-Gm-Message-State: AOJu0YxQVq5hf2K8SUmxaDthUc4vps9Y1oRxU0PI486uhUJsIDxMy0SJ
	aB/msi56ElL2GSkgydITQxFwZOzu9IBZzdYH7Fd46GEyfEuOGMMPoejnrJZlcyKCXyIDXshbnbP
	mZcygg+0KdYrgueI19oVK3MzPIHuND4TmVssI8Q==
X-Gm-Gg: ASbGnctI5wMEedt72Z/pNmABMvv9R0b3T5b4QI9JXA6V4raBfgW2Z3DUypw/asMO3Jy
	TvUbSRWNBdJZT/PKgh524/p/NSA9Z9ipl4Z9aKKsPcqYNESXwGYW1bBKPl9yBcCe9eY8ioJeyej
	RlPej5lyh5H/WLl8QEpdddaMDb0+dVMlwhINjhoderLYZqdfPUEJF73eO+Aa/osYBIKonO
X-Google-Smtp-Source: AGHT+IFwRv0VjE0s/GJ46BOQexbEb5Upg0Hji7i69VOssvtOIg/ehyb1QubPQ5OLohIIIsjfjU6LmWiGVEPvqAVtO4I=
X-Received: by 2002:a05:6512:2351:b0:545:a2f:22b4 with SMTP id
 2adb3069b0e04-54ad64b30ebmr4535451e87.40.1742934200566; Tue, 25 Mar 2025
 13:23:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 25 Mar 2025 21:23:09 +0100
X-Gm-Features: AQ5f1JpPH6ZDUnCojhOyjkakFsEShyIEY6JLnlsg7I56gqe3bOOQxr_zQzcp5wI
Message-ID: <CAMRc=MdO=vPrvvonJPJ=1Lp0vFTRBtsEBUS5aqWp4yMqUtgfzw@mail.gmail.com>
Subject: Extending the kernel crypto uAPI to support decryption into secure buffers
To: Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <kees@kernel.org>, 
	Jens Wiklander <jens.wiklander@linaro.org>, Joakim Bech <joakim.bech@linaro.org>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
	Gaurav Kashyap <gaurkash@qti.qualcomm.com>, Udit Tiwari <utiwari@qti.qualcomm.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Amirreza Zarrabi <quic_azarrabi@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Hi Herbert et al!

There are many out-of-tree implementations of DRM stacks (Widevine or
otherwise) by several vendors out there but so far there's none using
mainline kernel exclusively.

Now that Jens' work[1] on restricted DMA buffers is pretty far along
as is the QTEE implementation from Amirreza, most pieces seem to be
close to falling into place and I'd like to tackl
e the task of implementing Widevine for Qualcomm platforms on linux.

I know that talk is cheap but before I show any actual code, I'd like
to first discuss the potential extensions to the kernel crypto uAPI
that this work would require.

First: why would we need any changes to the crypto uAPI at all? After
all other existing implementations typically go around it and talk
directly to the TrustZone. That's right but IMO t
here's some benefit of factoring out the common low-level elements
behind a well-known abstraction layer. Especially since TA
implementations may differ. Also: in the case of the Qualcom
m trusted OS, the single-threaded implementation makes it preferable
to offload only a limited set of operations to the TA to not keep it
overly busy so a dedicated kernel driver can han
dle most of the crypto engine's functionality on the linux side.

And in general being able to decrypt into secure buffers may benefit
other use-cases too.

There are at least two points that need addressing in the crypto uAPI.

1. Support for secure keys.

This can be approached in two ways:

- We may expect users to already have generated the secure keys from
user-space directly over the TEE interface, retrieve some kind of a
handle (secure key index, wrapped key, TBD) and p
ass it down to the crypto framework via setsockopt().

We'd probably need to add a new optname: ALG_SET_SECURE_KEY or
ALG_SELECT_SECURE_KEY or even ALG_SELECT_KEY in order to differentiate
from the raw keys passed alongside ALG_SET_KEY.

The underlying crypto driver would then have to be able to select the
key from the TZ. In this scenario the crypto core assumes the keys are
already programmed in the secure enclave and
it's just a matter of selecting the right one.

- We may also prefer to do everything via the crypto uAPI, including
generating secure keys. This has the benefit of adding a nice
abstraction layer for various trusted OS implementation
s which differ from one vendor to another.

To that end we'd need to introduce a new af_alg_type instance that
would allow us to manage secure keys via setsockopt() or
read()/write() in addition to the above.

An example user-space side would look like this:

struct sockaddr_alg sa = {
   .salg_family = AF_ALG,
   .salg_type = "securekey",
   .salg_name = "qtee", /* Qualcomm TEE implementation */
};

sock = socket(...);
bind(...);
fd = accept(sock, ...);
header->cmsg_level = SOL_ALG;
header->cmsg_type = ALG_GENERATE_KEY;
sendmsg()

2. Decrypting data into secure buffers.

Here we'd need two things:

- passing file descriptors associated with secure buffers to the crypto API

Other than using setsockopt() to select the secure key, selecting a
symmetric cypher wouldn't differ from raw implementations but the
message we're sending over sendmsg() would need to c
ontain another entry that would contain the file descriptor associated
with the secure buffer. To that end I imagine adding a new socket
option code: ALG_SET_MEM_FD.

- one-way decryption into the secure buffer

This would mean that the write() of encrypted data into the socket
would not be paired with a corresponding read() of the decrypted data
back into user-space. Instead, we'd need a mechan
ism of getting notified that the decryption completed (successfully or
with an error). That could be achieved by polling the socket for
POLLIN | POLLERR. A read() on such a descriptor wo
uld return -EOPNOTSUPP.

Please let me know your thoughts on this and whether any of the above
even makes sense. If it's not a terrible approach, I will start
working on a functional PoC. Please note, that I'm n
ot very well versed in linux crypto so I may very well be talking
nonsense. In that case any advice is welcome.

Thanks,
Bartosz

[1] https://lore.kernel.org/all/20250305130634.1850178-1-jens.wiklander@linaro.org/
[2] https://lore.kernel.org/lkml/20250202-qcom-tee-using-tee-ss-without-mem-obj-v2-0-297eacd0d34f@quicinc.com/
