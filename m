Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="SPyMhDEt"
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75DA193
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 18:52:06 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1fa618c0e61so21743fac.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 18:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701053526; x=1701658326; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qI9CcSDLLstHRyj21IWoZ+bA+1wKLNybWTEpCFykIso=;
        b=SPyMhDEtqbnpufUeiooy6qsseAPLl3eau1IO7W7a1RwA9xAzWZYGzbuTYpmUWM5FDb
         38PX7DCRFuqKLZ7mm7noViyo6kP9LW2mtLBseJix2FuRkFrg+zgRzWJ6ppw4SzSy12dW
         UDlSzr70y5fuarXbg1xRvOqiF6cpOXejAc1Zysl+aGWkK33d15qco4FT6MxXRJu6jsvg
         Lqf+i/EIUnu/4/O2yAH3nU7Yc1Bcya9a5K+TbUUSRhiKnW5IGqZdqqYNOqBrlNFamjBM
         7MQUnuZcQtfgE0mNr1XoE/r1FPM8GxsEYJX2zgS4isGgDKnBlz09FlaGnXvLOPFh3sc3
         UzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701053526; x=1701658326;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qI9CcSDLLstHRyj21IWoZ+bA+1wKLNybWTEpCFykIso=;
        b=E3sycaNOc81Syi2DIFBTWfpGFAlpC1peOCMnihEKfCOrQoM0cmO6sS3AswqSsSDxjQ
         qCBl7zMCFr17pbMP9NQV4RTrxGRAoNTBsKkv+yMamzWVlP2QyBsIRlEwBg7f2+6CYRf7
         B2QDQY+ndAxkyU4u8Bv7reqxkLVBi1ezcjD9idC9aJg16UglJ/HPj9754knsTBS0mhJ/
         52QjP0sQgGHAj2MwH0Mbk1LbC/eTsLgkD7c/2yS/zxNFf7aBkPklHSeGujiigwFMTsV0
         DnDuEl81qkiDjifLyllGFHQS+VuejQPyXVcB6KT2pOrB9pfZ+oG7c3dyuKkZSntpI0XD
         j0HA==
X-Gm-Message-State: AOJu0Yz63lf8th5GI+Co81brwWw11UH+4hZ3wJdNirg0zG6yRm2LmKoC
	0XESrPZUoAwTpO09tWGN9bJpyzYa+Gfjn2pvYtFkew==
X-Google-Smtp-Source: AGHT+IEUMWOQwI01s5hv1fkkX+qTkj8fVqbeaE2jyE5V20loSNf/HwB1dt15pdwtT8kBz5cVsoeurg==
X-Received: by 2002:a05:6870:9a90:b0:1fa:82:3d6b with SMTP id hp16-20020a0568709a9000b001fa00823d6bmr12180340oab.9.1701053525800;
        Sun, 26 Nov 2023 18:52:05 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:95c7:2856:b238:775:b338? ([2402:7500:4ce:95c7:2856:b238:775:b338])
        by smtp.gmail.com with ESMTPSA id c13-20020a631c4d000000b0058988954686sm6632076pgm.90.2023.11.26.18.52.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 18:52:05 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated AES-CBC/CTR/ECB/XTS
 implementations
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231122011422.GF2172@sol.localdomain>
Date: Mon, 27 Nov 2023 10:52:00 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 andy.chiu@sifive.com,
 greentime.hu@sifive.com,
 conor.dooley@microchip.com,
 guoren@kernel.org,
 bjorn@rivosinc.com,
 heiko@sntech.de,
 ardb@kernel.org,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <08090C1A-E8D9-4C87-995B-8A7A195CE1AF@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231102051639.GF1498@sol.localdomain>
 <20231122011422.GF2172@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 22, 2023, at 09:14, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Nov 01, 2023 at 10:16:39PM -0700, Eric Biggers wrote:
>>> +	  Architecture: riscv64 using:
>>> +	  - Zvbb vector extension (XTS)
>>> +	  - Zvkb vector crypto extension (CTR/XTS)
>>> +	  - Zvkg vector crypto extension (XTS)
>>> +	  - Zvkned vector crypto extension
>> 
>> Maybe list Zvkned first since it's the most important one in this context.
> 
> BTW, I'd like to extend this request to the implementation names
> (.cra_driver_name) and the names of the files as well.  I.e., instead of:
> 
>    aes-riscv64-zvkned
>    aes-riscv64-zvkb-zvkned
>    aes-riscv64-zvbb-zvkg-zvkned
>    sha256-riscv64-zvkb-zvknha_or_zvknhb
>    sha512-riscv64-zvkb-zvknhb
> 
> ... we'd have:
> 
>    aes-riscv64-zvkned
>    aes-riscv64-zvkned-zvkb
>    aes-riscv64-zvkned-zvbb-zvkg
>    sha256-riscv64-zvknha_or_zvknhb-zvkb
>    sha512-riscv64-zvknhb-zvkb
> 
> and similarly for the cra_driver_name fields.
> 
> I think that's much more logical.  Do you agree?
> 
> - Eric

Fixed.

We have the names like:
aes-riscv64-zvkned
aes-riscv64-zvkned-zvkb
aes-riscv64-zvkned-zvbb-zvkg
sha256-riscv64-zvknha_or_zvknhb-zvkb
sha512-riscv64-zvknhb-zvkb

-Jerry
