Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70D62EB874
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882212; cv=none; b=XgqCZuh9beFrfAVLCNgv/MmH64STBxlMO49yJo1+X2QxL345HyF9MZFEGWrPgx3kpBPJgWduG2o7u6JToM1N4EehBrjSHWM84FpE9cz7ZN/tAMW6aJxfK/Oe0Re6RPEWbRyW/pHHJMxBrVONE7TnQzmS4H+rwFRtKg9idhvkUnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882212; c=relaxed/simple;
	bh=i55soKzyISPt6SeH7DsGUlC8BZVaYjKOR1DJ+cOhbME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vk3IHSVNxK2B3FHCUfhcH2woodS/motgPDZZSPHj07nXdrjscm1Dl+3gmzjb5VeV0AwxRM5H9HW9Mz6g4+pAZydrgoz2dPt4+W7IBrdENvNCOQaBRv6wsp5VR+x80cs2ck0ePMoQQ0cL1Le5ApVhBrkSWvJHxTEM19f+gPA8Jic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z02kSmB6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g2v8UYLc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z02kSmB6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g2v8UYLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774882209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ViefYB5GshkeJmDcmhUA4DB9x0JbvREJG28E0kRCIFY=;
	b=Z02kSmB6KITe+kVHeUWoWHI4eKyVfgNu7vaj3kh2U5HTnfwwbkHLo/SKTtwPnmo+1Ida58
	CGUcCQvJhkNsr6icY8Ig+X5eYNCI+J4cgkO/HlVMIzyU9o8M7BwNsC4HexRxusGuXsfh5h
	37VSurN36SpoET6nzXO5Hnfr8D3/j8E=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-usFEUkTQMt6sFLhCA0pKWw-1; Mon, 30 Mar 2026 10:50:08 -0400
X-MC-Unique: usFEUkTQMt6sFLhCA0pKWw-1
X-Mimecast-MFC-AGG-ID: usFEUkTQMt6sFLhCA0pKWw_1774882208
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50b31cff27fso42203441cf.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774882208; x=1775487008; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViefYB5GshkeJmDcmhUA4DB9x0JbvREJG28E0kRCIFY=;
        b=g2v8UYLc+5lUZCbeGy+3NZsYH3sOytXJMQ2BqC71X0KlpwQqOxvncJN2bH0EruVysw
         pyhHNYkzghXlYdI+hm8+GSFgMDGQaoiKLxPP0SjpKwqBZkMBSijkStHADsoiSzxcXuuD
         5VOSaFjOgdcqMBJFOcrywA0p8Oj+D9TSerTqHgkvjg+px1UZJLeynPaRE7HT+v/fA61E
         55WUkjRq8oZjxQ9ch+HAwvhuC1u932bN6sMwcyxVyXBUcVN0aL4AtddDhJZ+EEMUIBFJ
         4tzjfAk7fQuRLaHYDPwFt6wdKn1Jo7Ngz2hbtHq29Bg7l4oYGQBbkek0jG7J7WB/+Y85
         Im/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774882208; x=1775487008;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ViefYB5GshkeJmDcmhUA4DB9x0JbvREJG28E0kRCIFY=;
        b=Z5OV78S1tdw87V8Q/Yk3z2GAy/lp+Ey90NayvtzzjcNRmxKyzX/3Q1H5t3aCE6HSaF
         TrtQ/PwuwtihnYT2n+ygAOMTAKHk4K+IAK/64RXcJ4xgUluZS384EJiamMRGyoC/Bd4h
         5uC0A0IDkrUSVMlac3bVqMT/i/6EauSpa2fWdMgxB0z7gn4CgUHUM1kNlrTww0nEOR8x
         BuYNYe8pV8+xPFZxjPLKBDP1Q3ZTPhdpdfeYbNuqvmwRSAT7+y4GIMj3DoSt6lUiHVQ2
         CUOhqElcxBTJC1mi5+zTD9DMEx5Y+Q30/Nzd2buahIUwRKWdyN17m9ExMpIFv3mRfnya
         797w==
X-Forwarded-Encrypted: i=1; AJvYcCXmmdnlNKG9fM+AcS0df/C34fkkAJwnW4ZKbZAzqVTJ8wLCXcDPki8EjQUsA7JHUm0N/oZu0ov74614KBk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1tdlwK5yW1K27w73odpVvx+gaixFVd82CRhRMKXgrY2o9/Yg8
	rS4UOIhbaP6zN1zsJYeC2kSLahZj8Qo3tKISIdndVaaFc2Rtf67bqEHQZIR53yASX+55De48qln
	9yjRpXRlCwIvwR+9e+EEcEUTeHhJZKVyu/gCrAtriZcQetELhSHCO9WYab1bnj+wxQA==
X-Gm-Gg: ATEYQzyPzlvyF3jGfQDn/cSgpA8ABG1o23W2x8XNCke93eGu+zQHZTuxfwGknFILICC
	h+sQZbJhaIorPEHVKdEi0tVZ8+BKH6IhI2+HCyhq7e6KiYz8UH6Lh4BYgvAXfvQ62I0elgIHhWj
	D3hT31xFxxB3L8F8gVaZzMEOxPG0x1m84zi8ai4QL0w580UU/OEEc7fILwUysxH1RYhXoo+00Cu
	WXtO6j7L2sGCCzbwH+ZflOjopbpewU9Cr/ma1mrYr3dd0cJW3AcH4zel3IX4JR+NSNaZIuobeWJ
	lmvTwIiyE6VNYseWka4gaFF2TC+09L0ZcgJtOUkaCyvW64F6iCnB+qDEvgKgcpxSlI83tUut/H8
	rkbOVhpBslxMtwCUHCTkDLRDd0r2VCeYw5PB2tlpELoalpBDJl7E+fU0C
X-Received: by 2002:ac8:5744:0:b0:509:45fc:c88c with SMTP id d75a77b69052e-50ba3836f51mr188099681cf.19.1774882207694;
        Mon, 30 Mar 2026 07:50:07 -0700 (PDT)
X-Received: by 2002:ac8:5744:0:b0:509:45fc:c88c with SMTP id d75a77b69052e-50ba3836f51mr188098161cf.19.1774882206754;
        Mon, 30 Mar 2026 07:50:06 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50bb2e3ed5csm72731181cf.27.2026.03.30.07.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 07:50:06 -0700 (PDT)
Date: Mon, 30 Mar 2026 10:50:04 -0400
From: Brian Masney <bmasney@redhat.com>
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 08/16] clk: Improve a couple of comments
Message-ID: <acqNnIJl2PxEcxj3@redhat.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-8-5e6ff7853994@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-8-5e6ff7853994@bootlin.com>
User-Agent: Mutt/2.3.0 (2026-01-25)

On Fri, Mar 27, 2026 at 09:09:30PM +0100, Miquel Raynal (Schneider Electric) wrote:
> Avoid mentioning the function names directly in the comments, it makes
> them easily out of sync with the rest of the code. Use a more generic
> wording.
> 
> Suggested-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>

Reviewed-by: Brian Masney <bmasney@redhat.com>

