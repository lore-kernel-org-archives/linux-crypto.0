Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338513BC11
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 06:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725430100; cv=none; b=QeXc09DI+UE6GlwYrmHWj0kqTCmFNB4eSxnIObcwbgsbwGbIHBr7X0fHRsEwA7AvP3eIHDe4HFU2op30/yB6cT5FvA1mkeN1/KmVzq8xJ8J4H3Ul3bxR0/tf13+Awoaf33bU9tSu6nVANt7RyUnPGB2XWkoNZyx2rCYKggixx/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725430100; c=relaxed/simple;
	bh=5R+dj0u5ecG3gY5zJ+JEieXpPNPxN3caimK0qdixohg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DONH8trv/WkFkyRcDWPYOfxSv8d+lBjjq5JMFtlb3DidUQXQejC0OQYn7dx14HZ593f9PjgWMoHANiGLNpk2hOc+htZ1wKN/HzaAa0xZGyUcS7FPWGT+LN0pp7B6LrUdzUH3QXesNVpFUyPJQdbHUlccyPiKTcDAAPJnzCg5euc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLUQBreV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLUQBreV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A2AC4CEC2;
	Wed,  4 Sep 2024 06:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725430099;
	bh=5R+dj0u5ecG3gY5zJ+JEieXpPNPxN3caimK0qdixohg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eLUQBreVTvnH1KtstBzedpIWanK1Onehs6487qeT11H9QaMHzvVhudXzGEX8DySDQ
	 umFf5lXO3bzQrnXczpitctamblGzbV9yQgVpYTi6X+7sJHP1pHQzUOxmBNhciJM04q
	 hqV7IeFOLCYsf8TZli3xdyXr8QYJ3uyegC+Z4TzzgGOyfMCjlimnBDfPSBbnnHAwSp
	 WXpg3kJnHxA+6PBnekfnddzha8erPmXlW4nLx8oI+MqwbmY+esXj27mzmdxfN/31Vf
	 IPuVyYRw/mVhV+zv317SuHP3/a2agHEssz1yRDCI86IkzMPQKYBxBbzeJp67Iz5PFs
	 pj7d60/cPvVNA==
Message-ID: <b97fb256-12ca-4258-ac63-87c350395fac@kernel.org>
Date: Wed, 4 Sep 2024 08:08:14 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] SPAcc DT bindings
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
 herbert@gondor.apana.org.au, robh@kernel.org, linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com
References: <20240904031123.34144-1-pavitrakumarm@vayavyalabs.com>
 <20240904031123.34144-2-pavitrakumarm@vayavyalabs.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <20240904031123.34144-2-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/09/2024 05:11, Pavitrakumar M wrote:
> Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>

Please run scripts/checkpatch.pl and fix reported warnings. Then please
run `scripts/checkpatch.pl --strict` and (probably) fix more warnings.
Some warnings can be ignored, especially from --strict run, but the code
here looks like it needs a fix. Feel free to get in touch if the warning
is not clear.

Please use subject prefixes matching the subsystem. You can get them for
example with `git log --oneline -- DIRECTORY_OR_FILE` on the directory
your patch is touching. For bindings, the preferred subjects are
explained here:
https://www.kernel.org/doc/html/latest/devicetree/bindings/submitting-patches.html#i-for-patch-submitters

<form letter>
Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC. It might happen, that command when run on an older
kernel, gives you outdated entries. Therefore please be sure you base
your patches on recent Linux kernel.

Tools like b4 or scripts/get_maintainer.pl provide you proper list of
people, so fix your workflow. Tools might also fail if you work on some
ancient tree (don't, instead use mainline) or work on fork of kernel
(don't, instead use mainline). Just use b4 and everything should be
fine, although remember about `b4 prep --auto-to-cc` if you added new
patches to the patchset.

You missed at least devicetree list (maybe more), so this won't be
tested by automated tooling. Performing review on untested code might be
a waste of time.

Please kindly resend and include all necessary To/Cc entries.
</form letter>


> ---
>  .../bindings/crypto/snps,dwc-spacc.yaml       | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> new file mode 100644
> index 000000000000..4432defbe268
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> @@ -0,0 +1,43 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto Engine
> +
> +maintainers:
> +  - Ruud Derwig <Ruud.Derwig@synopsys.com>
> +
> +description:
> +  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto Engine is
> +  a crypto IP, designed by Synopsis, that can accelerate cryptographic
> +  operations.
> +
> +properties:
> +  compatible:
> +    const: snps,dwc-spacc
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  mac-mode:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    spacc: spacc@400000000 {
> +            compatible = "snps,dwc-spacc";
> +            reg = <0x0000000400000000 0x0003FFFF>;
> +            interrupts = <0 89 4>;

Fix indentation (see writing schema) and use proper defines. I am not
reviewing rest.

Best regards,
Krzysztof

