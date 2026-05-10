Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78572BCF46
	for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778436434; cv=pass; b=RqGXv80aeAQbxeCx7WdyvBKAIi4v/B/2X3adW+GnagIDQGvjMg2na5i7eenZ82AIt4XB/t3gPvvemkP6HXxNKc4tqCLbgeC10ZhhKB/UxtW08kLOO6zWWNVHNJqmEhzqCDsb0iHBOsDLdmNJSetPp/aTLAiRmmRPkYdOuAO9cqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778436434; c=relaxed/simple;
	bh=B/9PkITJMR854+53j7XQJ2o4B0fxddCNlnNjJN0jwA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hz7SKUEk7SyFgXaotuw0LlwP+30W9ip5zgb4ZpUhUhKAsM7yRWsfctspPvkaEY9BxNKntJuRWYQwldxwlr5MME87Wg6FarRWE1YS4M8o+Fuq+DZHH2FszQTJHYMCtpIz+VV5+5+lviKBvBtkbvdQaYh4MMEClM0HtYc+9bXZi5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=xd2nxrE2; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="xd2nxrE2"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a86c1fe573so3828864e87.3
        for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 11:07:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778436431; cv=none;
        d=google.com; s=arc-20240605;
        b=YoC6z4ulmE/42q358gwMhzhZmOpLKH2St7BpD/iCCID1exuNDqoA4s1ifavF+B3Ag9
         8lCkrASYVFJr0gikeC6vAVegAOao9OugszdizIYwAlqDpdvpO00tqbufMTcv6aGRACGO
         VQa8EnKlA2AURNlwFkAsb7Z6iKh8DHYdLnWgZffp3k+PZ8dCR8fDf1zA4xYGpZCnYUI1
         Ia+6+gtQeomsfCwS9BqrCkNnB2N6NGep6pBUdChJ39j+0EvP0gAXf41RSLtyzb/4rgHP
         r15RoI2bBXY3Vo7F6WtfyoAruKJhBwqg5XvI7qAegJ4/f9vE/hFKk0k3Ybrp2rH348Nj
         LJww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mPI9RtUtwfMsUB1RLcg9XhbB2p1KI0Jg9PNs9S7CB20=;
        fh=jAqABPue4CDiye6UAGuxzWeUe56tXgjJmIPMmH72Rbk=;
        b=K2zNtYgCyb7Zc7A2GO1MHevbhHUue5L599tFN1BK/EqDaU45r7zRi9a/3cCxAyxbrI
         3o1qGHJZl8ivwqWrv4vssYkJqkMDwAUj6sNjhKsbsKoJZ1cjZLukl/k73SzU5JNXZHW7
         kS9imKg4px3nlLmKwLTlBGdK28Pg5i7dF55q94yclvoDD1MjHHhJXiBt1I2JOw/2uiYE
         2bO6lR3dBS+dRUEpuumNbXGxCsAFeN3vYIC6ZjH5gjDsOxEMnVkJUxh1qEGaKI8FLpy7
         detuzINe+qvFA2VQY+fz4Jy4xdsYPLfiZGQwgreJmtO5EwmS+aZqJdboGRnI5lq/HdO4
         Lyag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1778436431; x=1779041231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPI9RtUtwfMsUB1RLcg9XhbB2p1KI0Jg9PNs9S7CB20=;
        b=xd2nxrE2rwAT9XPROHji45Y7YpK9Lj8wqqYVwjTqgaMJz/T1a0pi3r14co3QbcC+DB
         1/4Y3nhJBc0pDjz4bJ5G0wRQXnFdGh+e1UV32hu9+18QbspbZI9ZtapjgRmcIkYmN8/A
         s5i2sZWZaL/7qTGe3cYymFLJtdPu27BfAb9pRJ/kW1s6bvKOSKkPnyd2ENQyI/E2Uxos
         Kb5P+sJVgC8pCMhXtMlV3JppbqSy+KqJa5FFCmFTcYHk9ic8b4HcwLQRQ4JPzTHCVfbx
         i+GCaAWpzUEjVYQU5DwBa3Lb8upX9MEia51MmdOlPKXUUobvN8LcCMrj957XJu6cRCp8
         TXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778436431; x=1779041231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mPI9RtUtwfMsUB1RLcg9XhbB2p1KI0Jg9PNs9S7CB20=;
        b=b6Hcwd+rcS1piCLLTV0ka5YRAgi1VJRfToDS7FpFZ/tCTgEqNGz861Xwy5p2Qr9FCB
         Lg6Zv1WyEFEx/cVi9Qvg2BLltnFbj46WlvBzUpAeyoXUKRHh4U2p/DczPGUbe+wetSIZ
         NJW9NE22r3ju/uj8UiyjZeh7Cj8pPWmEbx0cK24nJrk4b9+fVOIm6ZHU93WYX13cesMv
         i8IEEUVSW76fWBy7vFPD7arPwbkLhAC3BnA/G/ZdX4CzQGDkJ9SQHIwfzETxwPEUX8CN
         1ZQPCq2b3omKk8G/2yDj4X53Ol8QMxOHowvxeQ3+ngcvDXwjK+bjQIY80G1ZI0wfMXD2
         Xjmg==
X-Forwarded-Encrypted: i=1; AFNElJ9a9/ol/Lg7jX3P9tCKb5ugMosuCGubSTGX50JT/JeDy8/Jm1ttPhwrxOy2rUhtItMw1KXC/vfvPwwWSCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ5R1sTmCRVRzez0tfiXpAAUbGJh9ZOlZPOmWlwqyU4seyndX8
	FZIKhJQJYHpvwycuOVVrO7V/sYIsnbPxIFMzV5rVwGt0BpQsD1ZAZ2iyLyEFMwjfTnqEYLjyeLf
	xhJHdLhKToC2U+8LHQn9rSXwWe6fT3naXtij9aNpy
X-Gm-Gg: Acq92OFQbrtMHyFlMoVei2uVLCkCKIVhUd2/o+YEnst1iX+GDCu2VIrhqP0Wnyw9sPu
	ccWPhMoXyINfewVgU5jFKjRZxlSy4IskkC6+mZXBHzaKlfbTTxE2WLffaIwHiCcr/JfL4eBLlji
	aQUtZB2GsdRCBycQV9wdiKl5tbl8+emIF7gNxYAQ0DgcT22CvxJNaGLqG8ICwBgfVUtvRVJ/QiY
	93l+F4Xi6eZ2lVJQqc8cNeMcYUQe6V6bM9KPyJKzvTpmnirlpPeR3wyN3G7w4FpY9DpOJnttLqw
	YE+GQz2CAKuPnk8=
X-Received: by 2002:a05:6512:3e14:b0:5a7:4699:d851 with SMTP id
 2adb3069b0e04-5a8b6c9c530mr1787120e87.7.1778436430400; Sun, 10 May 2026
 11:07:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALCETrVqG+1yErRJjkxvJrf=A+Vu84HTR4Bx1Pcd8G1C0PJcMA@mail.gmail.com>
 <14A441D8-5370-44BE-8732-99BF8107C3FD@getmailspring.com> <0b8bba44-f6bb-4d69-b9d4-5787c276d41a@inspirated.com>
 <20260510163204.GA2279@sol>
In-Reply-To: <20260510163204.GA2279@sol>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 10 May 2026 11:06:57 -0700
X-Gm-Features: AVHnY4Ksn57e9ZSnowz7i8VDuqmEeyTqf3rUkaTOYFnl29-9oyrpMeTvEmcHBgg
Message-ID: <CALCETrVLsFyo71Jk7pZ+VDSR+cX-tu_mD+RdpDe-q1sVw4wisg@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kamran Khan <kz@inspirated.com>, Jeff Barnes <jeffbarnes@linux.microsoft.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 10, 2026 at 9:33=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:

> In any case, any hypothetical security benefit provided by AF_ALG would
> have to be *very high* to outweigh the continuous stream of
> vulnerabilities in it.  I understand that people using AF_ALG might not
> be familiar with that continuous stream of vulnerabilities, but it would
> be worth spending some time researching what has been going on.


It would not be completely crazy to have a simple, straightforward
interface by which user code could ask the kernel to do a
cryptographic operation.  Think:

int compute_keyed_hash(int key_fd, const void *data, size_t len);

where key_fd encodes both the key and the hash type (HMAC-SHA256 or
whatever), and there is a very, very small menu of hashes to choose
from.

But this is not really obviously worth the hassle.  And AF_ALG is
definitely not the right interface.
