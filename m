Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794500811;
	b=eXcWaysxttiWoJTqN6CVBeGq2rZnvFvjcuRzXiqABOSL85I/e3TDVtZibo9XtdSlYIge
	 PZHWs6Sxsgcx9tPcYqf0X4JInYtALjh2TcMIT0Ibo1r4YTf6G8a8JslBXQ359ESIUvmvc
	 NF7XJOATrY2vCCG2ezTOXTu5tSTVkAbUik13O12qAg8F85n/R7ELn674IGrm3mYTV32Ji
	 85nYjSH2UQwhIOGstYAgGxM4K94DSvjjbTiUs1HfLFUaWRj8D8EdKo6O3yP6cIvkZMLzL
	 SYZz5exAg698w3ojw+omm8Q/pXwplUEPBXCbxlVbWK55h4DoL0WEWy6EgDBA76azifw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794500811;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=zy2nREmykWs6qK0x39KiCj1K4H7Cbhg1tuWFyKfn2Lg=;
	b=lELMEI/cqq4HVRFO4JEMplwWYaLTEP2fDppFrBn3jUsfubfKe4cN3JCuViYzhmMuqtsf
	 EopL3X7/vthnndcRq5JOkrMjLGDUWfrefWPpSJnOZS0DAN+H1tuGvCnc0FuT1ZjppX/SZ
	 8LaT0S28/MWFQUxjrqVGbApMcJEVdCIb/XOYDn8Fl1o7AYWqiNwUAbz1wcUp+NoJZ/SrI
	 xE+CkgIwK9DxUtYJ7OKt38bERu/pWs+6tswQzaSfZMwv1NC40RGUXGb/hmPb0WrirL34Z
	 EyJyclI2FeFbJKs1IfXza3wn466G5x4Vamx4fiSP+o28UHazdVazgls9MeP32ltxeVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=HNqWJUHT;
	arc=none smtp.remote-ip=74.125.224.51
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F93E606A893
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F93E606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=HNqWJUHT
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso2508464d50.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794500809; x=1795105609; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zy2nREmykWs6qK0x39KiCj1K4H7Cbhg1tuWFyKfn2Lg=;
        b=HNqWJUHTwskCfxyQeoQpVsfc6Sn+8MVV6e/p7gNcizD0bH+DpnjfRftZbx9USWAwYk
         RI/4mQK0M/Qh+4Ty3oYNPCJlvSCaFt9jomFXCxhZFe5T1DvUNta3sgw7XlUzypwkR0gi
         1oX/3IyDZ5Cq0RzYtKYalwmBuwMn2l4LnwJDeGYPZWMFBUAX03KCiG7N7x49lBz7ttjW
         ID2/FjiXCsP6ArqlB620Djz/XXhgS+lhyZ+Zr1xy4d2tQLHPalrUTCENa5IqxVMkDSAc
         CcJMviBVtEkYNTy8i81z/eshsD7HWaKMCmk8vL0m7dohP1RgpWl7XiR8lrzN/QneP++T
         rrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500809; x=1795105609;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zy2nREmykWs6qK0x39KiCj1K4H7Cbhg1tuWFyKfn2Lg=;
        b=UQ+XqQUKhNZQ2+0KOTFb6C53OoqDCnIvsf9Ql2kgt1Dz1MF7jbvtRtpdp0vKnCwkHC
         vcgoPSqBCU50Hj2BvYwXPI9zPsv8+epFVaKDYN4sSuIMjZfigonY2RB3EeqDFpQVk1p1
         Dq3oSoMV/Jvz/bNu6SGMpilxxAgo5nHYgjn3z8HyufTILfZuMbCam+IfTSfpW34JY/22
         FnAuOuHlWYn1N6OvEmHXbjWmcKHdfd3fodtWaGpyC5LeAIMnLOfEC5PWvsYJrdYneorf
         9jNw+cSAzo/hhwtKZObbN0VE0OpFuJ5INwwTGTPZemiagYfl36euOOiB60kPH/syIdfS
         W5mQ==
X-Forwarded-Encrypted: i=1; AL+hErHmJW7NyP5If7CNEIN3Bm/QckO41SKs/j9L0ahYfPNfu/VY1CVWHpBazYjCOe8U6ZCrNhclqbvpt2K2RpA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+tSVb1DgKNCDIkHEWbRhsC7+CKwOwm/PTvPUlca5R0eNhx0OH8
	lgRIIWeQzhza+ac1pd1w4DJglO0ZUtGJuB3pPKR9174fzMTBkuazfLiuLADcrrZaWHE=
X-Gm-Gg: AYBFou0uCPunQaoKYxebrZ0md2hGzs2DMcVpqnOm3XZ3l1QgZ8BPdQBBUX1/5ZsGjDL
	xKibAyg0r1Htu/S/2F6H51Eyl/IFavAWodD6YuP86QwIU+ukz5RRWPGO64ebPx73f0YtW48yLSd
	jsyOeh0he3ZmJfcUvUZDbrLigf3s086Jjf/MqSFqs5b8qwQ9ETtTEX7AR17Wc7LC+6l1MjRkK6y
	e1sXZUAC4rSNAjIR14Nyu3gANwxVvSviZpl3q5Ho59hnyKNRi0CmIijZwtm/3QZKxQ/b6//cnAT
	Tq/Y432b+TP2BkSjY1EnH+zgzBR5QrCntyU9skq9hr8EqwyIIjkfpDlBIW4ix7Qv/qcA5zscHo7
	XVDrKU3P5d9BsWUxwlnTfeFmLl46OJgguR4qZoUfcHGJA5inUPAJg7l9u+FRaM7WKYcZ+w7M/Vj
	ydiNDvQP96WlV9YRVs4gEicAL8KNoZZjyZv5qiC8jdRxlEQg+c59S5cHu/6upGs4ZToHPO00Z8D
	OUqJmkTq574MiQCmJzd1DlsH08GYAFWJe97baNBmzn+FsO2CxCLZDEmlD6F3yIu99CYRmuRyp7h
	o1G5OLAFMmL6hnY6ReorJZ8csCLZ
X-Received: by 2002:a05:690e:d01:b0:679:a2c3:b294 with SMTP id 956f58d0204a3-67c67ff20aemr3211748d50.83.1794500809370;
        Thu, 12 Nov 2026 08:26:49 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c589cf1fcsm7627342d50.13.2026.11.12.08.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:26:47 -0800 (PST)
Date: Thu, 12 Nov 2026 11:26:46 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	terrelln@fb.com, dsterba@suse.com, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, riel@surriel.com,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 2/2] crypto: deflate - use vmalloc() for stream workspaces
Message-ID: <avXoxnMq6ns8AK0z@cmpxchg.org>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
 <20261111153532.1036709-3-usama.arif@linux.dev>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111153532.1036709-3-usama.arif@linux.dev>

On Wed, Nov 11, 2026 at 07:07:40AM -0800, Usama Arif wrote:
> The deflate acomp streams outlive the transforms that use them. One
> stream is allocated during transform initialization; additional
> per-CPU streams are allocated on demand. They are freed only when
> the algorithm is unregistered.
> 
> In a 4 KiB-page x86-64 build, each stream requests 145,320 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-6 block
> (256 KiB). vmalloc() needs 36 backing pages (144 KiB), 112 KiB fewer
> per stream. Across 384 populated streams, that is 42 MiB less
> workspace backing if all would have used kmalloc(). There is no such
> gain when kvmalloc() already falls back to vmalloc().
> 
> Use vmalloc() and vfree() directly, as the crypto lz4 implementations
> already do. This uses vmalloc address space, page tables and
> bookkeeping; the figures above compare workspace backing only.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
