Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793703674;
	b=tI0td+crB3/uY7az9wlnJVeKXpZDpbvi6k8Kk0Y39Cjb5xbT/1ITXG+iAXx7chIMbbmt
	 KtZ9y8VmZ2Dt937ym5ShV/LHUkapzXO7ZqfJATf6yR0Pct5WKNFujjSZ10l/5d++jn28w
	 8KadaDwXJMLfE42btARtae+fpSLiJFMb8yJzWFNPBmMxXVsnFEpce9uf7cb/YAVzt0VkW
	 xC+Gl6GBHycjf5giXlKTdgblI+tWbCnOm8GXyDNHbv7+gy+Y0LNC4V21S/dDL7rF3b2pn
	 LXNTPRnbwnyCmYH3rPHFsf3pQgb8jbA4Hi0EHiz4ezcUCJzYWca0e0Ql3/csIw9X48w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703674;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=sn9Od1d1g96GmgUVpWI8H/bAOkp0jHvgb53RStXQYfQ=;
	b=lOk303onfA0AUxpKos+6nRQ0vWtkK4AXrqIQPRtaQp4+y4vg46DFtIg2fslvoi0X5/mK
	 wwV8+liToj0RZWa8+i/JlhbXfUkGshdTiP2gwCu6P4n4lqSn0lwb9AjDTfEhINw79dx/6
	 kbZ7nA5Ej3WNgkSoaaNJJUCkdjOPDLiZJYA8nfnT79paTRkTK3dovaJ8otCQL18sd71rj
	 x1pU0xaIUpEW/xV3ewdsvcUN85kQmUSO5xeEUJAMFDfIEXLr5zeSUtamavrl96Dlggmbn
	 2Ka+CZ7Khy46P+FXrdnNKgni9zQYV9fMbrI/HGY46HFTZYyxPsCv+ipae6TG4IbS65w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=thegoodpenguin.co.uk;
	spf=pass smtp.mailfrom=thegoodpenguin.co.uk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DA9606B107
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 11:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69DA9606B107
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53644b28706so62800671cf.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 03:01:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793703672; cv=none;
        d=google.com; s=arc-20260327;
        b=exaO3k3DAfSc75SiCBecR96O2iCnlINttD9ynL6G4MxlYQYVMtep014XngvYfO2qm6
         HgncmI5hWJOz+t9nlRV2nXii3WVYfabKLy6fYs3fdNLFy+lfXRl20BoQtLiEUlmkWKCN
         aicEJDgdRDWSbfBqXoMJuJRdyNpXzJcZQp7XBcL2S3BG+wDzXNVMbT6Rf9kQCNo0pjzp
         vXojd0on4CCJd1IK9GdHpWi1M2SA/Qajmx2CpYsn8VWcqtuGOXMy9cEAZnWweIrKl3GN
         99esGkhRXTjPJUoymLekeNCzECqx6pvM+eh73IK1eK4G3XzupztEA6Odp5AAC2C458af
         7+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=sn9Od1d1g96GmgUVpWI8H/bAOkp0jHvgb53RStXQYfQ=;
        fh=ACOkJ9ahw9IKn+XKrbzteFDHHmtBp6d7HWBQBG1F0PA=;
        b=mnNkeVqZ+0M4FasCxFfV/r4IKM3ZvAbwnA80LC/roSdzsrZeeCpA6MJK61N64IMqXr
         u73PP33omkakhyvMSNYxZCseiCb3qAUfrBgGVAbwOE7yCkJQsRoSpHXAkyKMYZxTHWBU
         c03gQkiPF95y7Z4rp1lZpvsvlAUMeoVqrtJst67aOks3oeP35mp8FQVLY6mnIynSzMHK
         QOJEpIos5PY4gG8nBN/awv4Ipgy3bMmGno6RtT47EarRM4z7QTGBlFCidWrkfKZxoRi5
         YpG2Cxe0Xd3GBW476UgOE6m09MEFMoqxpwKjtPXBn0Q9w5SvzXLhjGvsPrxR7al7JW58
         l/Pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20260707.gappssmtp.com; s=20260707; t=1793703672; x=1794308472; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sn9Od1d1g96GmgUVpWI8H/bAOkp0jHvgb53RStXQYfQ=;
        b=Pz3Y4KMeK2eY7RaHYtlKu1J7sH+3HT1AN9Y1jhkU1u1BzolllJGseg6l0Oh+TO8WmZ
         I787+KldE1OJsVNQ2eZ1lqF2kjDacSGnXeu/o+LOEpxQXmQVkfUFpS/62LO1lxz56G9f
         RkPsCCf8TfPczShU7BO/ULwQqV6l2XIQ/vMOl0YzKXnRMgfI74WdLvnUjgSHxJUWWSok
         iUAV/T1HLxAGh1up7gSomvRNV76+6VaXaQTUcMC5ZBRjgjs71nHOZ27jLrBWjrnoqx7k
         oQDdoOjRZnn9TbtLI3DhY2XCnZ8HBCxPVNA6+eJIfEUPR5CAJ3UmuUeWgkypprr3KVHN
         xFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793703672; x=1794308472;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sn9Od1d1g96GmgUVpWI8H/bAOkp0jHvgb53RStXQYfQ=;
        b=u+2hpIMjBJf/JwlI88W5BrHQAnOyXkIFSaogr/pVfQAhRP6Xzg/Ndj3kMJ5jN52UdG
         Y2Xk7MMGbUxnJGsiKfCHM9eONxdAWW6s5c3kZx/creyHxElckc/CKgEY2q/xunOB2gjU
         OZnoWSfeEzRquCvV7pvhSgIjNQ5tUg6wwF9DTDuwl1/Xec5Tw4150bxdQQi7wCMXNyBk
         kOCpzR3EfGV11LgWbSl8g8Rhu2z1p59Hbx2iV7RX7UN7V2oDgQVACSvU+GZQi4jEPwnQ
         9squx7cf1PHdyGT8n1ALXkn4xbePha5dK8COzS5w7cCdt3Ln0oRof7qYQSm7T9l28FIW
         V0WQ==
X-Forwarded-Encrypted: i=1; AKwUvByBchBWMFOLu5t6xqYcNwNRz9JF86mC8g1cZlZ4uQuoCtSD4CjUj4HlDTIaPCXR9D/4SYHpCTe0/GMY8Fk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/DbDy6UI/BDIcqOkUjfGEk8TA1lFuSCyvkBnZmGPClW1xQ+Ohn
	Qz5NkYTYEw/DuJNuccWguYdDF/zu8Bfmb2/lPGGVXlUziaAnIHxcB+/IVwx5umb+EVMDv/piN2O
	zbDgHHbapCSYBwLNmHMT31/Ru7G7vj4Q2vJbFakSAjw==
X-Gm-Gg: AYBFou2/+ndChgzM/UZxtwJtKKt16dpXc5XfWOq2LxnpA8odSS+yvH3CfwQ830B03nW
	N1Wext51Uen0bJcln4woSsJX4OkaCR6XgYuLHqyRIrNBzLUl4BephymM8RaMM+0upoSHuBmwKLW
	PdcJugrd5r8S6BekD+t1LpgTJBXYbXP6eavNDu8gfWVVn5Rno+wQqfMqau9cgylniBaQEmdfyv8
	j1LxzIomAAKf+3fAgGXMpHQHChV/gJJ0wPAVgicAboLZ4dCyf8gfDUqLSBVp9fq5XT2b4qQwVgR
	cjt8cAsLaKNu64vg9jF98NBTVJ2omn2JtskgJPZulnlxKrUcq5BXQe/rxroR/swHa90iVsn/5hO
	UfPm0huA0iJg3LTO6Inu4Gy3xCpIDhsWRJe3O52ZOL8X6OcP+GHNydveeBpsLMBvLW4yscp0=
X-Received: by 2002:a05:622a:1386:b0:537:f05d:6ae9 with SMTP id
 d75a77b69052e-542b62a5744mr204134421cf.13.1793703672263; Tue, 03 Nov 2026
 03:01:12 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-acpi-mfd-v1-1-d61029971be8@thegoodpenguin.co.uk> <aum3RLDLDa1gllge@ashevche-desk.local>
In-Reply-To: <aum3RLDLDa1gllge@ashevche-desk.local>
From: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Date: Tue, 3 Nov 2026 11:01:01 +0000
X-Gm-Features: AclHuK-r_cJD1goYWPornsINa7shzhekDP8lLl1_99QVlK0QEb0lwrUHquiGssM
Message-ID: <CAA6zWZKqCpD8GLjnTwAOnBq+Uhq0fA=eCRm4tkX9YDeiC=h2mQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: Use named initializers for acpi_device_id
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>, 
	David Rhodes <david.rhodes@cirrus.com>, Richard Fitzgerald <rf@opensource.cirrus.com>, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, Zha Qipeng <qipeng.zha@intel.com>, 
	Qunqin Zhao <zhaoqunqin@loongson.cn>, Thomas Richard <thomas.richard@bootlin.com>, mfd@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org, 
	patches@opensource.cirrus.com, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Can you split Intel LPSS to a separate patch? It will help reviewing both parts.

Sure I can - will do in v2.
