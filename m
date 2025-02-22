Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5605B1DC985
	for <linux-crypto@vger.kernel.org>; Sat, 22 Feb 2025 12:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740227512; cv=none; b=Uiihqf8Iq6i6Sc0kibLa+Sid0KKIO9yd+ffV96z4/dQhnC6ZBAMtN9+WkB+iVfQ5b3ppscofnSh9L+F+c4HFbui5p+DWcXWdpkH9BcC0JxyK+IESplym7Q4+o7ZjAGmWDAx62etqXIiDL2UXGxNclHa5KYZeNfY5loO6rn/61a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740227512; c=relaxed/simple;
	bh=H5VZ+AzcMDDSp+rSHY7kV+abXJqzCU4+rgQjNAkzN7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwIsAmdtOKVA/mTPCAf+qo9/XBzXOd+DON0D2N2+jO99YCiGBdsW5W1Z8y7wcXDugWhXHpFr3CQxZyYJOWUYZi2SCegm7IrRtbSn/9czq3d9IF2mGOi9plWTqOOTCczm/50EMJttIe+eaXke1FdBmnUdsODhA6Y6QdM6P0VuIZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=hDZeE8Gy; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hDZeE8Gy"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fc32756139so4722083a91.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Feb 2025 04:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740227510; x=1740832310; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XBQF6pBy+4ocO8lCtdZYh37OSSsL3UX8OWQxKrmEKV4=;
        b=hDZeE8GyM7uju+bCeY7Ui34gNklIf8ZXL7SuDeHU/xvborgRsrp+feH12Qv7lBQanR
         X0eu78qbcABg0BtaP9+ptf3LEGB3G0mJ3XXXk4IrwJhL+qYuvrsUWD9EL/a/S+Rd+AWt
         oYqvVxEQVUIsAF9pEPZenjOg8D1KUJAVBwiMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740227510; x=1740832310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XBQF6pBy+4ocO8lCtdZYh37OSSsL3UX8OWQxKrmEKV4=;
        b=bPLZTkdhEwGmVAfj0q6RjdKuGSkn3OKsONNP9znUDHVZ7NxitAIvL3waoKwgsyzI/j
         gFw+CIN9ZNTe8D50mTjp0SngwMK6ES8Fg3HKO4L6oBBc3FLt9BeC/DC7dlM97HaLd/6P
         svB7LECllhfn9+/CmQmP5iT2uRWtLXb6la4PzbsvNsvdTF2UwAOE50yP+FqlVgXcohzF
         a4Ki8gZEIY9pIxCyHFTaRlMf9i91BTQY1LrFeL07JCCUwltkpgwYVNxNH2plvPPtET/Z
         9Q/J6UY1A7xvQA8NBTgQGmnMKK3VdMGkAmF9BeKSHWWdMheXsgoHNNzsfD/IVA6i1aGN
         od8w==
X-Forwarded-Encrypted: i=1; AJvYcCWSprlVxzbFWBIikYUT7xOCqmWmGnrrfZ6134d6JgTY/Cl+QmjnWwl4GOfkiAvn/qg7uBeSuVghu+jT5X0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyILohGVOCDE2q7zpda2ynjWLR5D2XHgyPaAD9HbyVG8REpkCYH
	94ZT/j+M8tC0h7dqwnAtFaMeHak32WBMkYbfrmXydQfmBFUkRn++ru/+WYTBLA==
X-Gm-Gg: ASbGncs48ZybB1hq3qB0AvJYMIxC1QmslSN7PLPyBMfvk5Ftg4g4A1Uc6eTDTG4HHF+
	S5Czx2iyEDpFE6vEdJBfnOC51mOF+HifToMA8I4/nhNAq6IyjtA/eij+eQjJrDBq0Jfyk/mjZ5Q
	gxpKFxAxB2DiQ1ftmJfg8OIdBFftMtaanE0lZyEQL3AzR+2LuFPgd5yq5FFTZBnvD4c4CKlzU5w
	LO/CLH07fFt8keEfXvfCpBUsYmpcVzdiayuZ/O93wCHixPaY3cylEpDbafai2PpuX6b0S0MibFC
	G5HlYvwl4yVe/Ta9wcRRJEW56uTC
X-Google-Smtp-Source: AGHT+IEA15yK2MW8Tlp9hdnICyGJRc3eshaBlXjjjEiD2bra2pzxxjVvTfyZrcRJPMVj5WmDs2jqQA==
X-Received: by 2002:a17:90b:3cc4:b0:2ee:ee77:227c with SMTP id 98e67ed59e1d1-2fce868cbb8mr9543078a91.3.1740227510563;
        Sat, 22 Feb 2025 04:31:50 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:badf:54f:bbc8:4593])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fceb10fad0sm3094015a91.31.2025.02.22.04.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 04:31:50 -0800 (PST)
Date: Sat, 22 Feb 2025 21:31:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
References: <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>

On (25/02/22 19:26), Barry Song wrote:
> After reviewing the zRAM code, I don't see why zram_write_page() needs
> to rely on
> comp_len to call write_incompressible_page().

[..]

> zram_write_page()
> {
>         ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
>                              mem, &comp_len);
>         kunmap_local(mem);
> 
>         if (unlikely(ret && ret != -ENOSP)) {
>                 zcomp_stream_put(zstrm);
>                 pr_err("Compression failed! err=%d\n", ret);
>                 return ret;
>         }
> 
>         if (comp_len >= huge_class_size || ret) {
>                 zcomp_stream_put(zstrm);
>                 return write_incompressible_page(zram, page, index);
>         }
> }

Sorry, I'm slower than usual now, but why should we?  Shouldn't compression
algorithms just never fail, even on 3D videos, because otherwise they won't
be able to validate their Weissman score or something :)

On a serious note - what is the use-case here?  Is the failure here due to
some random "cosmic rays" that taint the  compression H/W?  If so then what
makes us believe that it's uni-directional?  What if it's decompression
that gets busted and then you can't decompress anything previously stored
compressed and stored in zsmalloc.  Wouldn't it be better in this case
to turn the computer off and on again?

The idea behind zram's code is that incompressible pages are not unusual,
they are quite usual, in fact,  It's not necessarily that the data grew
in size after compression, the data is incompressible from zsmalloc PoV.
That is the algorithm wasn't able to compress a PAGE_SIZE buffer to an
object smaller than zsmalloc's huge-class-watermark (around 3600 bytes,
depending on zspage chain size).  That's why we look at the comp-len.
Anything else is an error, perhaps a pretty catastrophic error.

> As long as crypto drivers consistently return -ENOSP or a specific error
> code for dst_buf overflow, we should be able to eliminate the
> 2*PAGE_SIZE buffer.
> 
> My point is:
> 1. All drivers must be capable of handling dst_buf overflow.
> 2. All drivers must return a consistent and dedicated error code for
> dst_buf overflow.

Sorry, where do these rules come from?

> +Minchan, Sergey,
> Do you think we can implement this change in zRAM by using PAGE_SIZE instead
> of 2 * PAGE_SIZE?

Sorry again, what problem are you solving?
