Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199071;
	b=3XOivYT4dqMC7a83JEr02uO3Z21yyrgZUlWPbpFQynj9anHAtw9Il0GPRxZNSgWC+PQs
	 IzGdC8+13M5uR6SBomfO53eHOhP2st8YzQBbWbOfhXUGTAvWTQgBLNZA+0rKet/uUmbwk
	 rHKE3k0atE91752fCNt5XDUPxdlUNk0QM50LqJcqcFD2vQrRvuYbF+XSFXkTS9sA5l37W
	 5Xxzph8qgM/5V04PYVZoVX2fFc3Oo3cUmnCcydm2Soh/ul/iK+dPl/szcvGM1DaE1cUyw
	 w3aWOQDjqXWz529VKR4Yo7IN5dMgRQP0Vm22wUnWn/i30tS5VFkAdCBDHPUu71cEtcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199071;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ug43qQts6gDuZkuchi5FUzqrEwboOJCBBSHYXZMY/S4=;
	b=xn3E7bSoUwMrgC+xYG7nkM69JnF5reEdvERgPQrV2GrcxoV35f9M8qpG29IwG17XCOV8
	 bdWWm3mQvPZzayQY7Mqrz6lFUW3YoaprFZCAZSHULYOf05zyP0tYhJ/eP5EaB7vacrbln
	 kfwpUXeaP2xjqAOf5eXNuE1Go1sN+Nsc42Nk1Bwut5Mov0HI6BqSJd0T1AQlvdarkEXKs
	 /PWXuliCJpo0tyqXBtdb2a0pP2W0i1ruUHjW9S7kD5vmHGh/JYXBzUEXGF5RX35ZXDrq3
	 +Cpb61P0CvXpRsjDLJIsN9V1se5FJsJ4OBnGIaPAHtPCGd8Nlg3C5V2DhOJYkNES11Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMluKOLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A23606A31E;
	Wed, 28 Oct 2026 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMluKOLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465101F01828;
	Wed, 28 Oct 2026 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199070;
	bh=ug43qQts6gDuZkuchi5FUzqrEwboOJCBBSHYXZMY/S4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RMluKOLviz+Ct3J2Wy3Xk3+fpXHwBN8wkd2rTQFVpk8MDEY3An467I6G1waDkLfUb
	 VkGRs+h2B24EJvrK0ySisYsWH+cQbnAUlxksG4EQRljv43zjUYjw8f6Z0XfSO38yxF
	 xAFii0j6cA3Ug37MbkJTm67Xg6KVeH/0hfR8R1CIz58f/vGWi8QA9c1Ke67u+MODf2
	 KJp32HqJMqsSJYYEQ3z2VpFioZ6wGVBHcdFfv0jaIQMZP6aMBO21RB68+MWDxFumal
	 ZMPd0LXmnTCPjSOQoxliQAU0dTjzjSjKisolkDVK6y5wew9t3QxPGZmwXG0eNSd2VT
	 BmQ23rn6E5RvQ==
Message-ID: <76e47b43-2f00-4b29-bf2b-afb6fa0387d7@kernel.org>
Date: Wed, 28 Oct 2026 15:51:04 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
To: aousherovitch@rambus.com,
 Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
 Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
 Thi Nguyen <thin@rambus.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
 <20261026-cmh-b4-a-v7-v7-1-500a83faf500@rambus.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20261026-cmh-b4-a-v7-v7-1-500a83faf500@rambus.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/10/2026 20:44, Alex Ousherovitch via B4 Relay wrote:
> From: Alex Ousherovitch <aousherovitch@rambus.com>
> 
> Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
> hardware crypto accelerator.  The binding describes the parent
> SoC-level node with its SIC register region and one queue@N child
> node per mailbox the host owns, each carrying a reg (mailbox instance
> index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
> rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which
> crypto cores are present is discovered from the SIC CORE_ENABLE
> register at probe, not described in the device tree.
> 
> Register the 'rambus' vendor prefix for Rambus Inc.
> 
> Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>

Why is this sent multiple times?

b4 diff '<20261026-cmh-b4-a-v7-v7-1-500a83faf500@rambus.com>'
Looking up 20261026-cmh-b4-a-v7-v7-1-500a83faf500@rambus.com
Checking for older revisions
Grabbing search results from lore.kernel.org
---
Analyzing 8 messages in the thread
Could not find lower series to compare against.

And both variants are present in Patchwork, so not sure what you want us
to do here.

Best regards,
Krzysztof
