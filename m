Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="XehcGEKn"
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B5519B2
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 21:32:17 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cfc2d03b3aso25511225ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 21:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701235936; x=1701840736; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sj4mmJIBUQjwsLyHUMay3Il1zQC/QaufE2Lzb1TCd5k=;
        b=XehcGEKnQllIjLwTV125DL3Q5TcTaQyhujMtSCEIB9bYMk4ynuO1fsPWRACWBwrQ8w
         wAynnqFls6La8FoXFw8GU3wB/5hCCTEOXzzLjtXtYBd+5vSeSEvSbb8R2bGfmk4nf9Sn
         eRxIF4EH8/WJLA+UmiC+xyVEuxslBf5+H7plw4KZ4E0yl8IgqBQ2y0RbZ2zUmlgToUWd
         mn1xzD5wWSACfZ9l5Rjlv/LO0NV9vV+VPnfzD8D8SP2IkmNWBHtxHa3eRu+pbNyWwqqY
         tJ2cPRhYgs+HuAOKnC1hlkPSfobG0tkijodZL5ja18ezEH0nkI7kqy1Zfle1Wf+jrlpn
         KMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701235936; x=1701840736;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sj4mmJIBUQjwsLyHUMay3Il1zQC/QaufE2Lzb1TCd5k=;
        b=ciFo9lYD/rellf3SL9gBI6AAuEzwYbasvVmQ3oH3fWGbls4HTvuD1APPzk9mvVMwHU
         gvOuKBaUGTbJyo3r3ZpGUR2nD9ilpqtKwXROX8WJIkAh3/T3mfekbD4cmMIxIlbQUJ9d
         LIq9zH5kgaxlABe2caQiAcXCMJ4fPtYbFDr/7ou+09l9NTkFqXeHVQJuIfSxlWO3mkyL
         p8hpYoeqTWFEp7vEYjpc03NC89ais0E64iTkHY6OViAV54wWfJp93WpVTEzz6Wbg12S7
         9tZPNllcLWrekZM5WrYqv2GiQf4kC8FwtI9OVXF/OsxNXhtHWOcYCrOgzGW1dL8QV5cN
         6nqA==
X-Gm-Message-State: AOJu0Yw0XTeLVbZArpAhjNlPz0HwaolxVG8l5Fxt73k/t6fIxvsp2tgM
	2dSzcZfa0oaHWZoOObml10Qs6g==
X-Google-Smtp-Source: AGHT+IGFsjXCW/Ho6O60mLG49EAl+1QT8CzD7tPecYI3HFKFAodNBvFnLj0US/gDsjpY2a1LcMzpWA==
X-Received: by 2002:a17:902:7005:b0:1cf:d795:5e4a with SMTP id y5-20020a170902700500b001cfd7955e4amr6885924plk.15.1701235936505;
        Tue, 28 Nov 2023 21:32:16 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:5a34:50a0:78b5:5013:4cf4? ([2402:7500:4ce:5a34:50a0:78b5:5013:4cf4])
        by smtp.gmail.com with ESMTPSA id ix6-20020a170902f80600b001d00c25c282sm1236711plb.18.2023.11.28.21.32.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Nov 2023 21:32:16 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v2 12/13] RISC-V: crypto: add Zvksh accelerated SM3
 implementation
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231128041314.GK1463@sol.localdomain>
Date: Wed, 29 Nov 2023 13:32:11 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 conor.dooley@microchip.com,
 ardb@kernel.org,
 heiko@sntech.de,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2E9C9E5D-D03B-4038-AA6F-D30540390816@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-13-jerry.shih@sifive.com>
 <20231128041314.GK1463@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 28, 2023, at 12:13, Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Nov 27, 2023 at 03:07:02PM +0800, Jerry Shih wrote:
>> +static int __init riscv64_riscv64_sm3_mod_init(void)
> 
> There's an extra "_riscv64" in this function name.
> 
> - Eric

Fixed.

