Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268496;
	b=CPmEhDFnXbGhLQ6LlFNdfF5q6Jck/74qd3Se85F8IgD7SYsI5RD4I8WEMFqKAnvKIkEB
	 ob/nfkmPPiuqRlOUfQQv1qC2Y86L/inWzpjbDBHHW090DjHCc/jy/2Hc20ypg2b8S1Rs1
	 E5Q6QtEp/0sP9+Tm7z6dRfFAhcwAlaKlR7MuR/A5NFiThdbYuOfkfr0Ava1vYOsIDsVLl
	 1hVC3BJ41qf9J7UL2fWsk3JcspV/m62FkyQxQmar3vD3EyP+A7j1VOFft1w24faC0S1Qn
	 aijnNLAd4GqOXxHTYd6Rtnpi2T0zbMElt3jyslXptj6nUVv9gbTQbwcAPN5weOFWMwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YqJZ0P7+7fLRIuROPGM5CtyVNeaoNZ5CLQZzkAwMRGI=;
	b=CSwqpVGqVphkhkxVi6b39urjeMA5Gt2VBT6r2QXHDU2LEB4SXChxEfpW2SBWsb7Pji0h
	 w+1kn1zO+qK/IVIgEqeH3L35UvDTqvWxSzTsTV/b1nXeIrruzWQRLbW6hAVB70mk8OW/2
	 hvapLy09MOR4Bijz6ncGzIpyAsykoMSW8uVnmnZh/feuKVXPAwwykQ8g9JRQKoTViZifs
	 +F4pD3AE32xlsTDHKUiRu0aM65J2HuHzQj5xUhXu9OveDFhXs8Os91372B1No6ERHso42
	 0ZtiGIcNNg76haN3X6jW+M08gC2T7xzimOzclJFPZw/3043fL3Pz4l/hgf3dk9dFAGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="W+1f/+mm";
	arc=none smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3464C606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 10:08:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3464C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W+1f/+mm
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5ba3b1199f6so2028445e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 03:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793268494; x=1793873294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YqJZ0P7+7fLRIuROPGM5CtyVNeaoNZ5CLQZzkAwMRGI=;
        b=W+1f/+mmtUVeicMuk/ydwLlfIFytKQiJMmkoEo3ynnRRfaKT7HiLSfDiAd1/Y+PwhD
         8cfrCfRXamJpaAPt+sWuYsp7BdH5yz6uF3NU77u0Zj7LMibQRIglvylRCLJ0Qntw7rM2
         BbzvZSf5xbOzbQHuDIBrzREi0Ymns/KxwgPqynRUeTyJI+rxoHwyStZYDt7QrGJ2Hegd
         WwS3AFgQWxpcrih0E8/Dm+q0179BJUhZnSNN0Lgaw8UxVWfyauTB3/Q1gcCe4/aTuHXP
         DI20dQ62MiGtD07UdkgLwuEEcMmCwBlFxBXbVPyL2eFRAKI1y+W33XmqlUpXNupMzcss
         ws9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793268494; x=1793873294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YqJZ0P7+7fLRIuROPGM5CtyVNeaoNZ5CLQZzkAwMRGI=;
        b=fmBWwoMglf1rt8SWJAU0QsK5LWgJMayaY/6VFZLMGE3c5pPwArrZTSbGvCU+lnrzZS
         abHAnPO1+5XhgAuvnoCwUMzNR3OFqeQGy0FghCdOUN4s7N9JR6tcKK+XDyBn4EmBX/86
         IuIiXIBP/bUeiV3DENhVY7KYABziCHSRbJ5doZaC43puDXF8POSO8lqtkZUnxLk33RqY
         SY2OFOP+dfBiuTXceGQuBFcWcKN/MFL6AsXcZ2EP++Xycw4FEHcter0K8oqK9p4944uX
         w9tTC9kq++20D7mTQRJO02icf3fgiYIk2dgHk1oFbVLyUTLQyfchyHM8ZlrguWRhclZM
         7AnA==
X-Forwarded-Encrypted: i=1; AKwUvBwRsB0SB4VEHlqcn6htdhz/KfV2R7F0uZ8eo1GwXJ3Y2jm1MKxzzHHmPZR/oS3zrWe6SbahJF68eNlDITI=@vger.kernel.org
X-Gm-Message-State: AFq9FYJpJGQl/6FQb4c8WiyEKkgcmon4Ve67uZ6uN67iIAK5MGkNa60O
	WnJCjg/pNlE1RW56jGXOJlON7ujHwlmFWzBvCATOXwJqWzVKDyl1a/X5
X-Gm-Gg: AYBFou0t1OZEs8emMU33HNG5WN0k5zD4ZlAc7rer9EXUbRGvZ7axSbmYrZc69z4BwDr
	+164Q/aekN7GztrpgqYNruofcNoXhuNEbzMLMyq5KfXK7QinHco0oReB4miX16tnGO3pefgA5XZ
	++8c+oukT21Ym5wYOWf0saPKLAOHOdrkVJ/3Wl6EiF4BQ6RwLrYV5bNThKKnRpIc8uyhZGwsaVF
	RIeBrsTMDmdaSM+n59pvLBI7IXip8La3YiLUrTTu3xCSqsDL+GMN8PiomdnVqSz3V+hgFx4w0Vs
	1mw3ztASmmLejiB5m+J5CI26rDEPKlyGzaa6DaZ6TLO0gwscFqSYehvIiK3c011BMyHHw2FZQev
	rJ8TOKZnG5cGr8biwqYCOjuiQ0dn6LOv86WMGj+kGI7S8h7QMgkBtF30j7XP41rD9O6slcHO6eZ
	iNJGYw0cC8OPFO2eVJYwyi0bcsejw/X4tnakp5Dq+km30TD5VYgaY4+kB5om3CCKRV43SP2/ylK
	mlG/Kful9psJ9lMRa7raWHKsHc9dtsTG4sF4tvqfD4c4NQ8ZB07B/wnzozjFBr0EjdHoKzsTsnr
	UEKfL3NUBvpbbSDooFff1LxBRsasnBDsRAYE4zfSQ2KYvrOMzNI84a/OeE1VxpjeLbRDjh8rXPk
	neqcg
X-Received: by 2002:a05:6512:2512:b0:5bf:d56b:a71d with SMTP id 2adb3069b0e04-5bfd56ba77emr273419e87.46.1793268494124;
        Thu, 29 Oct 2026 03:08:14 -0700 (PDT)
Received: from pc636 (host-217-213-144-15.mobileonline.telia.com. [217.213.144.15])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfca5bb57asm1109637e87.74.2026.10.29.03.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 03:08:13 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 29 Oct 2026 11:08:10 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auMbCuecFeRmBFSK@pc636>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
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
In-Reply-To: <auKshDXKQXt1kvjy@gondor.apana.org.au>

On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> >
> > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > while another CPU is inside vmalloc() or vfree():
> > 
> >     RTM_NEWNEIGH                      vmalloc() or vfree()
> >     ============                      ====================
> >     spin_lock_bh(&br->hash_lock)
> >                                       spin_lock(&vn->busy.lock)
> >     rhashtable_insert_rehash()
> >       kvmalloc(GFP_ATOMIC)
> >         vmalloc()
> >           spin_lock(&vn->busy.lock)
> >             waits for the other CPU
> >                                       softirq: a frame for the bridge
> >                                         spin_lock(&br->hash_lock)
> >                                           waits for RTM_NEWNEIGH
> 
> I think this is a fundamental bug in the kvmalloc non-blocking
> support patch.  How can it be used at all if it is susceptible
> to such dead-locks?
> 
> And if you can't use it safely why don't we just get rid of the
> broken kvmalloc non-block path and have it always go to kmalloc
> like it did before?
>  
If we have a look at this as we did not have vmalloc() here:


     RTM_NEWNEIGH                      foo() or ...
     ============                      ====================
     lock_bh(&br->hash_lock)
                                       foo()
                                        lock(B)
     rhashtable_insert_rehash()
         foo()
           lock(B)
             waits for the other CPU
                                       softirq: a frame for the bridge
                                         lock(&br->hash_lock)
                                           waits for RTM_NEWNEIGH

Same issue?

I have a question:

GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
not hitting ABBA dead-locks or they are not interrupted?

--
Uladzislau Rezki
