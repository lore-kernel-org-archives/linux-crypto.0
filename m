Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793865159;
	b=v9MzO+pMuomBtSkvcQp6zQaW22oUhB6K2ki5eEVVrP3Qw1l/AAy8YdRIhF4AZqM/89Bb
	 Y7d00DA3YEyh05GnrS079lHYS98NThjOFBLO+nM6Us8ixg2E8oVqbTTtUNyPHx3Ghr8NG
	 xblj8jFKeq3a2IRz4mndKAYsh2izdPPX1QOm1xdo8cbqHiLBUJqyv0YKKoTMcXPmxMbMn
	 HiMVpltGGI5slgx/49Oab+NUPmNy8Z8fUTkcRYQxbL7aI5vpfeiRbWHLl8S1D0kX2j3Cc
	 s9wPoddRkyH18ygs0uViDN0nelyefGhnIU4XqVpHNz7iTIXUkjLAdflHY1cA0qe6JNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865159;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=UJ312eBsn1Ygh4FvbElLwVY+HLtQNYmxjBGI04ZaxcU=;
	b=ZVLk5lM8TXCBK8O+D/MlQSaBqncsVOyKuE/toyd7W2IODnjomoE7KfaBSAqKZ5oRqQXv
	 1EaTYAAm7UXjW3F93J11KLISfqBzfCkEwB1/05+YhGTMijcEnFPcZdSRyQgaFAuZeTocu
	 EFDr2plubPgj/CRCBItcn88WW2yYTqfy7RpJfth5yJ+zgHFskV/k7Ngxn7j4gcuJ9QMes
	 EXUp6+FAttoOOtqPlxl82C+yxiNzwGBOMTOX/OboAUt2txap2V62NU6vb0eOOk2R6dZ5P
	 M3eXcVVlyyM9xFN0/A53CRvhDDusFYpTja0qDOjqcRLl0mlwOd6LjWfhOIbUlkcs32A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=thegoodpenguin.co.uk;
	spf=pass smtp.mailfrom=thegoodpenguin.co.uk;
	dkim=pass header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="fj/Utz0+";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.170
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026B6606A337
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 07:52:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 026B6606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fj/Utz0+
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-535179e995bso15807361cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2026 23:52:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793865153; cv=none;
        d=google.com; s=arc-20260327;
        b=Ta3SqmsEQ0BStlcKOSQ1PAeBIpoCwW9lhRKrApynkI1WJG3AEG+mkBLEWA0n///wK7
         RWZyzXQdg0ny85uUJBR08700p+kOThx9uL0uUF3zss2MOMk42EjxhjROd71YGU4uzBdn
         cvP81JxagYzofyLFEHndYHTZvxqgWCUl3SbFtWHpa3QV1CnV9YIt7DaeuYbN9py87AFH
         VmiNIut/OVfYWi55OFDhtQMiqXTizIQOH5skjRKB88uDtNemLREzgzDXaGAtZLp7os4e
         wbWTx6uX2JT13w6UQ51jrY+DqONPCHbdPurGIczoJcjTACIR3hjYRbaEqLb31WjA0HMk
         fTqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UJ312eBsn1Ygh4FvbElLwVY+HLtQNYmxjBGI04ZaxcU=;
        fh=5uOkUWVqFIA7Ft2uOtqkwaec+PN4XeCX6PD+j0hxJvM=;
        b=LklY33KfLtYiD+XL4/H/iTq/iX6REON/Z96tDL3ozL1cqLDnbvt0HKB9uAlFdcf+ze
         vwHN4U4Nb+AmYVb0s1RiVEZJbDp4O78j2K909z4RJdJ6M4CRgAbrQ+sXfrLQyFAlNPrL
         6w+2L56b+hGhe8h3yJlxKLieBf2FOKY5uLHHMqPBlCckd+gOeY0SsvHIsxIXix+ROkm3
         F0SOAHkr1n3KdMmEYLlgcjMkwho3yP0GjYeKxtRjG3TnW54DvCqGIGG//BSlfBZOUM6l
         4ZdMFtSJ9+Nak76iOS6hRNfRVTLMp9etanhE13rYym1Zz/oqFu7hPgdWB/i63ZhkSdFS
         WLdw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20260707.gappssmtp.com; s=20260707; t=1793865153; x=1794469953; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJ312eBsn1Ygh4FvbElLwVY+HLtQNYmxjBGI04ZaxcU=;
        b=fj/Utz0+Y60yxuICoU+fCjL6rWSodnNW6GiJHpZFeQ+K2c9r1QwILznm9v34n66don
         oJmzfyvtULO2tr6wY+lSqq6zbRaU/rDDqXMmthU+VRX3LXLjyEd+frpxnTny+Zi6Bl40
         5aZFwvUXnt+aJD703LqQYGi16cJJa/n+KXmo6ZTgZv0HO08YeC/iQQlgbb6ehBs74UJC
         MqOimmMyxrchQL+wAPHSdoYvcUvNohjaX/Wfa4A3hfbTpbjwXam50XCSlFCHfrdVIki0
         zQQ45uBjHZUMzFHITfSuog9dfvY/WAx1yFsc7j/TyUIyCNISIizr7gkGXBMA7YHDjJzJ
         AWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793865153; x=1794469953;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UJ312eBsn1Ygh4FvbElLwVY+HLtQNYmxjBGI04ZaxcU=;
        b=BC4sV5JJpV43S+AwkcVlKVyD8w7KfsPwe87uto99Czd9CmqVAwLBGmmq2+npZAHGMj
         g23SS5oz0QpBNhZtVXvOMltuneLMa7TpPNDuodpLkK2C4227PmnPDTEGC4pK2wi+ZU3d
         7qrDMFsZWYhq9epxtGoRLeXUX7/iWJS6Qxj4sKW4JgDalUvZQenrOE2blMvjkvRnJ4Cw
         3/57Sfye8KnrSJ8gDy3Swm22/lsoQJ773RAGoh1qahirvgPXttgtKRdWM5Eal/w2dG55
         ROTckwQBulkXnYQVvjzUxlVb8dPBGc2H00AV6g0sCWL4xKRVmikEFyN9xJHmccxrYvKq
         cqgw==
X-Forwarded-Encrypted: i=1; AKwUvBzxeB8w+Nk5C2vI4IHrxb37qwzheDh76KR6B2so/0OWf87lE0PlbSW3JpnIkRilfqMPOyTu96hnxv+yAjc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/R0exdd4VlZ6iFaAhCF/b1eIaDLenhtrkgh/Pv4pHJJqwfghmw
	9cUniWE/mUFDI5f6aWP9z1+9kPCArM/INC69vwBZ1urzJ01MxqVjuaSuH1Rpvwcvxf6WaLpC6Le
	KYi0ZJ5DYZIunXVpF1VeLg09zn+Tz2LDozab6Zx3m5w==
X-Gm-Gg: AYBFou1rkYrPckHmuY7owbYuQno/GXCvKhUrLryyQ7Y3crEF5CUClkaaA/1B6RSk0v1
	n78BK85409UMy6+o/r4fpUTFHclIDST/I/DnaZgyzEs6u2Hj/sVuJBhDiX/NrjZF8XtIqU/bLng
	bEhZTzL6oy+gdtTvA8F5YCNCWjG6jMXEqq9sLN1nSQ/rzXhkFGTlW2LbGx7NY5oQPS+Lg6IlZ2n
	yMDhQTLn4ZZQ0VMPvLezYX1/rN+EDj3qMaq5aRSrhUi7FG9Ag2wh2ksb39gxuBqNduNYCoS6v87
	vvELXV4QVmQjMAhO/espG7G8emHlyNdsIN+tQv+4LnMsaF7L0jIHDaZjB3Dg7W7Wq0/Lm26lkZX
	Vzri6AgH4rlLBOt6T6RIXbY5IoAEaaGdYvrtiN99Smkw1PtwPR7Mop3eza4dvfoF30xhofC5MmF
	+cixaCiD5VmKG3Od7T
X-Received: by 2002:ac8:5e14:0:b0:536:79aa:de06 with SMTP id
 d75a77b69052e-542b781c097mr305348781cf.52.1793865152881; Wed, 04 Nov 2026
 23:52:32 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk>
 <20261104-acpi-mfd-v2-2-64b9dee3baaf@thegoodpenguin.co.uk> <auulmL-HXdzcdM2V@ashevche-desk.local>
In-Reply-To: <auulmL-HXdzcdM2V@ashevche-desk.local>
From: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Date: Thu, 5 Nov 2026 07:52:21 +0000
X-Gm-Features: AclHuK8oxaHoF3EiK88-RObp0nE6JLTdIkoUzrIpdnanDmHfkYi6XSLOF6A9rt8
Message-ID: <CAA6zWZKk9C_PnZKZueYYCT=XHcQA7r4SPM4MK8zWHLyYuxS=Uw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mfd: Use named initializers for acpi_device_id
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>, 
	David Rhodes <david.rhodes@cirrus.com>, Richard Fitzgerald <rf@opensource.cirrus.com>, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, Zha Qipeng <qipeng.zha@intel.com>, 
	Qunqin Zhao <zhaoqunqin@loongson.cn>, Thomas Richard <thomas.richard@bootlin.com>, 
	Andy Shevchenko <andy@kernel.org>, mfd@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-sound@vger.kernel.org, patches@opensource.cirrus.com, 
	linux-crypto@vger.kernel.org, Charles Keepax <ckeepax@opensource.cirrus.com>
Content-Type: text/plain; charset="UTF-8"

> Haven't I given the tag for Intel PMIC drivers?
No I do not see it, the only reply on lore and in my inbox from you on
V1 is re splitting the Intel LPSS.
