Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F72278B4C;
	Wed, 19 Jun 2024 22:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718834613; cv=none; b=eo+mcgb4tjTFq/ogR5zNAS/ExR9qgLWEexiX4z1/uaam6CxikT5pHYnKtTycjxT8neYvhe1qdXIqm+r6SEhrP6cDCK0eZr5+PgQtqZbX3M68ZgyWslJUrcCYcq5oqNezt4ePAjt3SEJSzltgiXAEw/D88Cm6UvMgPJVrhAXLpIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718834613; c=relaxed/simple;
	bh=mcwK4c39DMeRB8MPCVbr8QblCM6+rcjSKJN1zD5d3j4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dPcnrx/U5V3Sk/yU7mxZBFMltjoqAW/LUbMs3cNVI/2mOdiaTSK0G1nciRoP/nOCLC3/Oo2Tb7VnilvqnDd+oBziq2ugALOhRXsUa4ZmtLmL4QAqpFCjDlnMNr9VhAsFDEReu6XpOHzxT1uDv8u5yS1q59QCOhUMb5XUSyeuwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uj8IPWDj; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uj8IPWDj"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ebeefb9a6eso2115671fa.1;
        Wed, 19 Jun 2024 15:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718834609; x=1719439409; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Yq4IAyyNsYAna0ESkuw1f7o4G/47mVNnGHyj+w2903c=;
        b=Uj8IPWDjhOojGAwTmiNuD5ELuZTwkG9ZxA4qfHE8f8fCnTiN9hm3p9kKCIhFPHiKtp
         b51QIzYFBu1tWMAEewaBLU8xQo/J58pX1F3NUgso2RyZ2tceA9YyhUhT6OrlDNyYtHOv
         7CBIj6iqLx4DsFZQ5Yq5Hp/cMYVvHFvK8Lg7HxAikdOq9mrDI4xH1h4Fl3pd8e9yngSX
         FrTAVPm0oKjKDvvM4Sk1b2lzZ50h2QjSO2S/GskidcO1YwpOal3KfLbv8Q/WECWdHX0Y
         UejyQPQVevlMNLD8Q715CY8C39bT4w7Kxl/XRzYbVW0W0OsIot8B+IhYzLjbnco/fnDm
         Mlug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718834609; x=1719439409;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yq4IAyyNsYAna0ESkuw1f7o4G/47mVNnGHyj+w2903c=;
        b=cTo6JEjKE+PUoYJYlidBYeGn3ikKaDe0pZpQ/VRFdksBZ64i5WOlxMmjQYj2kPCvwk
         KLiyl7iRje2yVsiIJ4XIvO7TeSLX/NQ01xlhZ07WGYA6lbg73gUO/PGfvqedTVgJw8VK
         qR/YKmGyjXQxuojifEiigTa2XKtyDa7eEc9lNSGDXSEKNn1QdZ0AHq73IOohJysNYVb2
         xX8kXYKxn4fq1YuPkrtlzVd9Bo6hrr0cPxfRN1Tfd6/J3ff3coUTySuqzKrtjTyhzKnR
         0itbpFR1A7z3YwUfwfNgPeJloh9k731EkrJnuYGGjQcds++qHwAwvDFqIh5Gw/hoKRva
         Kpyg==
X-Gm-Message-State: AOJu0YzmBVjbJ3h1sOlTSGGqDgmUixTSIs33gsmfys0JUFDF++AJFtGQ
	yZt+amM+xH9aHOFLTocCABZM8uJUTnx9pEVuZt1P3TcNpFCJO+gzs8+isujyqiBfM2NXR/QcnBw
	RcFeElNDKDOWn/QrJ8xHtKzEJoCydIWw5
X-Google-Smtp-Source: AGHT+IHKKUSpMTSlgdTIekfoDmpzp/Qw+g/i34H+2uTBBEmaYHzHLiyfEYiNBO/xru4PzFCKA8dH3t93h2C3xrNvgIQ=
X-Received: by 2002:a2e:9bc3:0:b0:2eb:68d0:88be with SMTP id
 38308e7fff4ca-2ec3ceb577dmr20982551fa.12.1718834609164; Wed, 19 Jun 2024
 15:03:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 19 Jun 2024 17:03:17 -0500
Message-ID: <CAH2r5mterW6Qqyz=oirYr1iV5jLRAvfU5yGGd2MOqpkwaE0qhQ@mail.gmail.com>
Subject: how to verify which crypto driver is loaded by crypto_alloc_shash
 when more than one available for the algorithm
To: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Was trying to see which driver was loaded by:

   crypto_alloc_shash(hmac(md5), ...);

and it was confusing because it looked like there were at least five
drivers that export that cra_name (most presumably hardware specific),
so was wondering what is the "default" that would be chosen and how to
tell which of the five ended up being used.

-- 
Thanks,

Steve
