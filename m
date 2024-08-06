Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A54D9FE
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722967092; cv=none; b=YDa3gU8HdFy0S8y6augO/BN/6oV/WIpGcm5qSoAnigYkNz5TQnzQB3z5wmRW+ypFENJvMNDMCpB6sust8LgF/WT5/2amUnHl00WF2bRTrLHG1ewiBBmetmo3FuU6wOQRe/w3/31l8mewxyHggDXi13VlECQSuPscM4uxpBeSxCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722967092; c=relaxed/simple;
	bh=+XQ7EXMdWCbFPGv9kbd8F3/RPDksmzSI5wQvNzLG3Pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RHJZtt3wVYlRRSEOZdpyyzNMzTGCqvVYMAs32ZZp7JMAYGyR+Ro07Rzz1yJD0tiokbTqqfgyX65p7FtGPPqQHOOWmBtKCz6aP10DcTLUOKsqnA8kTilFDqFrxyHYF+ATYg6za1H38049xtvi8cZjjzzObvDmDDRLzYZV6YbUuws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TzyMVAKj; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TzyMVAKj"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70d25b5b6b0so702931b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2024 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1722967090; x=1723571890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ppbCftp1ElER0LaXnbFFh4A++DaUu3/yzzf2j7fAj9E=;
        b=TzyMVAKjX1fkzyrDcHxqgDqCCljDGem9cSA45ZIEGpXccmu/AP+Khh9O+JP/Zo5Ij1
         m+s0t6/rGwWvtcJqgprRE3njcYhqUEIHQ/Ncn6L2gpHROUISr1X8gnTKFC3c/rru4bOg
         yMiRgyAnrMho6oodZpL8r8zexp4BJ/AXJZ1kM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722967090; x=1723571890;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppbCftp1ElER0LaXnbFFh4A++DaUu3/yzzf2j7fAj9E=;
        b=Fo2Cru6HP3wyia8HxB0luGoswMgKG/ytLiGTONsv+4JQWPQZBaNhg5Vs34bVpellhS
         ia9dgLsJsPxbPh9fQ/DoQL+1QbDZRiWLNtYwaNj4nADV0qsyXUrIa14v5bMGWQcNTuCo
         wMXivdiXvQtCc5/IfNsHSlEeqlJDLM8MHtEw3hcrS2A9riGm0/5FjMalL/SLVQ5DFjJ8
         Y7HP62Of3kzHZK2Lmj7H2ui+bSoXTmhx7PzKREKKTEhk8K+1c7SkmhtDVsF8HITgzUvK
         4zLVtMJ7w3KAqiZu1/IumqW3nK/6lbeha0zVs5ttl4ylmyp51oh7t67Fs8JbHj3TsOyV
         gDsQ==
X-Gm-Message-State: AOJu0YyFuLdPRosN9MDxy+lLSpI9Y95rO0xgqyMW1x6dcOUkEgypjdgv
	bILYm/4ZeBXQLoWSyQuafI0xUb+J+KCVguPhlFmVuOkInV7NyaVANPp1DRBEyQ==
X-Google-Smtp-Source: AGHT+IGlg4Lc5q+qLRUxBPDwU3kas2zcCPaLlwEOMc259PYKKdX66kDBJMRs67f27fZZRd6xA/wrYA==
X-Received: by 2002:a05:6a21:339e:b0:1be:ca6c:d93 with SMTP id adf61e73a8af0-1c69966a10dmr18630724637.52.1722967090260;
        Tue, 06 Aug 2024 10:58:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ec01235sm7201913b3a.7.2024.08.06.10.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 10:58:09 -0700 (PDT)
Message-ID: <3bcaa79c-2716-4211-9bd2-620f3cb1e54b@broadcom.com>
Date: Tue, 6 Aug 2024 10:58:07 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 1/2] hwrng: bcm2835 - Add missing
 clk_disable_unprepare in bcm2835_rng_init
To: Gaosheng Cui <cuigaosheng1@huawei.com>, olivia@selenic.com,
 herbert@gondor.apana.org.au, bcm-kernel-feedback-list@broadcom.com,
 rjui@broadcom.com, sbranden@broadcom.com, hadar.gat@arm.com,
 alex@shruggie.ro, aboutphysycs@gmail.com, wahrenst@gmx.net, robh@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org
References: <20240803064923.337696-1-cuigaosheng1@huawei.com>
 <20240803064923.337696-2-cuigaosheng1@huawei.com>
Content-Language: en-US
From: Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 xsBNBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAHNMEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPsLB
 IQQQAQgAywUCZWl41AUJI+Jo+hcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFr
 ZXktdXNhZ2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2Rp
 bmdAcGdwLmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29t
 Lm5ldAUbAwAAAAMWAgEFHgEAAAAEFQgJChYhBNXZKpfnkVze1+R8aIExtcQpvGagAAoJEIEx
 tcQpvGagWPEH/2l0DNr9QkTwJUxOoP9wgHfmVhqc0ZlDsBFv91I3BbhGKI5UATbipKNqG13Z
 TsBrJHcrnCqnTRS+8n9/myOF0ng2A4YT0EJnayzHugXm+hrkO5O9UEPJ8a+0553VqyoFhHqA
 zjxj8fUu1px5cbb4R9G4UAySqyeLLeqnYLCKb4+GklGSBGsLMYvLmIDNYlkhMdnnzsSUAS61
 WJYW6jjnzMwuKJ0ZHv7xZvSHyhIsFRiYiEs44kiYjbUUMcXor/uLEuTIazGrE3MahuGdjpT2
 IOjoMiTsbMc0yfhHp6G/2E769oDXMVxCCbMVpA+LUtVIQEA+8Zr6mX0Yk4nDS7OiBlvOwE0E
 U8AbwQEIAKxr71oqe+0+MYCc7WafWEcpQHFUwvYLcdBoOnmJPxDwDRpvU5LhqSPvk/yJdh9k
 4xUDQu3rm1qIW2I9Puk5n/Jz/lZsqGw8T13DKyu8eMcvaA/irm9lX9El27DPHy/0qsxmxVmU
 pu9y9S+BmaMb2CM9IuyxMWEl9ruWFS2jAWh/R8CrdnL6+zLk60R7XGzmSJqF09vYNlJ6Bdbs
 MWDXkYWWP5Ub1ZJGNJQ4qT7g8IN0qXxzLQsmz6tbgLMEHYBGx80bBF8AkdThd6SLhreCN7Uh
 IR/5NXGqotAZao2xlDpJLuOMQtoH9WVNuuxQQZHVd8if+yp6yRJ5DAmIUt5CCPcAEQEAAcLB
 gQQYAQIBKwUCU8AbwgUbDAAAAMBdIAQZAQgABgUCU8AbwQAKCRCTYAaomC8PVQ0VCACWk3n+
 obFABEp5Rg6Qvspi9kWXcwCcfZV41OIYWhXMoc57ssjCand5noZi8bKg0bxw4qsg+9cNgZ3P
 N/DFWcNKcAT3Z2/4fTnJqdJS//YcEhlr8uGs+ZWFcqAPbteFCM4dGDRruo69IrHfyyQGx16s
 CcFlrN8vD066RKevFepb/ml7eYEdN5SRALyEdQMKeCSf3mectdoECEqdF/MWpfWIYQ1hEfdm
 C2Kztm+h3Nkt9ZQLqc3wsPJZmbD9T0c9Rphfypgw/SfTf2/CHoYVkKqwUIzI59itl5Lze+R5
 wDByhWHx2Ud2R7SudmT9XK1e0x7W7a5z11Q6vrzuED5nQvkhAAoJEIExtcQpvGagugcIAJd5
 EYe6KM6Y6RvI6TvHp+QgbU5dxvjqSiSvam0Ms3QrLidCtantcGT2Wz/2PlbZqkoJxMQc40rb
 fXa4xQSvJYj0GWpadrDJUvUu3LEsunDCxdWrmbmwGRKqZraV2oG7YEddmDqOe0Xm/NxeSobc
 MIlnaE6V0U8f5zNHB7Y46yJjjYT/Ds1TJo3pvwevDWPvv6rdBeV07D9s43frUS6xYd1uFxHC
 7dZYWJjZmyUf5evr1W1gCgwLXG0PEi9n3qmz1lelQ8lSocmvxBKtMbX/OKhAfuP/iIwnTsww
 95A2SaPiQZA51NywV8OFgsN0ITl2PlZ4Tp9hHERDe6nQCsNI/Us=
In-Reply-To: <20240803064923.337696-2-cuigaosheng1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/2/24 23:49, Gaosheng Cui wrote:
> Add the missing clk_disable_unprepare() before return in
> bcm2835_rng_init().
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

