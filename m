Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DC91957FC
	for <linux-crypto@vger.kernel.org>; Thu, 27 Mar 2025 08:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743063368; cv=none; b=o/ccI7QlfbZAnA7IONUFGLTLQZWNgCZ+tyrsAoEXtf9ATQvndAyMnDSOjdNHGFjPCeB3NG1KPFPCG4xMlLG/rt751T304pJsDDryGtDb3+qBTLBG6Mrw5aOihp2fwcwE4eGniwDx65OqBMPc0L2obqr+pJGvm/jKLtCUGMo2rF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743063368; c=relaxed/simple;
	bh=VgC0/YLysb8HZ1h09PRRyYlQv3TXvVg+c9AXKcyGSKE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZB4LJUFVwUY33OUSnQLPrKP2oCqnnuWflzL1E314ogSibXp/3Ac6Pph49OGyG8I3kcSsOxXCKAEjyYdmAgIIvkSo11Cwu+v3FvjSM4EWOJgJzj5n20FHINZnUSj7tKOr1KlRD8j7bdTdykdA+3JmkhCu+s8C9ehcKH3yOKcL5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=yEbYfGXK; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="yEbYfGXK"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 52R8FuDi1797468
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 03:15:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743063357;
	bh=yuazkzinHyqha3/to2se2VsUozde/3zJTVb1jmPueyA=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=yEbYfGXKf0gOkY0ZGhZv8TCk+DOsMAgnx+vGn5L8QwS1M29pSrOuJR84aUp6eEmMl
	 x5lWT5XUlds/4vM698Fui/LjzsQuFjvGtKH+Fhc2Gef633Q+v5Jsslrjea8zMNzQIL
	 uHSDHw5l3KWJyuTXraCfmu83vd3mxr6U/7yMUXc4=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 52R8FuQt018068
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 27 Mar 2025 03:15:56 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 27
 Mar 2025 03:15:56 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 27 Mar 2025 03:15:56 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52R8Ftkq092407;
	Thu, 27 Mar 2025 03:15:56 -0500
Date: Thu, 27 Mar 2025 13:45:55 +0530
From: Manorit Chawdhry <m-chawdhry@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers
	<ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey
	<megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, Udit
 Kumar <u-kumar1@ti.com>,
        Pratham T <t-pratham@ti.com>
Subject: Re: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <20250327081555.nhcggnqxetwbnidx@uda0497581-HP>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
 <20250327073427.amcyd4t6qvs7kw35@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250327073427.amcyd4t6qvs7kw35@uda0497581-HP>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 13:04-20250327, Manorit Chawdhry wrote:
> Hi Herbert,
> 
> On 21:06-20250326, Herbert Xu wrote:
> > On Wed, Mar 26, 2025 at 06:01:20PM +0530, Manorit Chawdhry wrote:
> > >
> > > Thanks for the fix! Although, it still fails probably due to the
> > > introduction of multibuffer hash testing in "crypto: testmgr - Add
> > > multibuffer hash testing" but that we will have to fix for our driver I
> > > assume.
> > > 
> > > [   32.408283] alg: ahash: sha1-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(9/13/uneven) src_divs=[100.0%@+860] key_offset=17"
> > > [...]
> > > [   32.885927] alg: ahash: sha512-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: use_digest multibuffer(6/9/uneven) nosimd src_divs=[93.34%@+3634, 6.66%@+16] iv_offset=9 key_offset=70"
> > > [...]
> > > [   33.135286] alg: ahash: sha256-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(15/16/uneven) src_divs=[100.0%@alignmask+26] key_offset=1"

[..]

> > 
> > This means that one of the filler test requests triggered an EINVAL
> > from your driver.  A filler request in an uneven test can range from
> > 0 to 2 * PAGE_SIZE bytes long.
> > 
> 
> I tracked it down and see [0] returning -EINVAL. Do you have any
> insights as to what changed that it's not working anymore...
> 
> [0]: https://github.com/torvalds/linux/blob/38fec10eb60d687e30c8c6b5420d86e8149f7557/drivers/crypto/sa2ul.c#L1177

Added some more prints.

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 091612b066f1..0e7692ae60e5 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1176,7 +1176,13 @@ static int sa_run(struct sa_req *req)
                mapped_sg->sgt.orig_nents = sg_nents;
                ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
                if (ret) {
+                       for (struct scatterlist *temp = src; temp; temp = sg_next(temp)) {
+                               pr_info("%s: %d: temp->length: %d, temp->offset: %d\n", __func__, __LINE__, temp->length, temp->offset);
+                       }
+                       pr_info("%s: %d: req->size: %d, src: %p\n", __func__, __LINE__, req->size, req->src);
+                       pr_info("%s: %d: sgl: %p, orig_nents: %d\n", __func__, __LINE__, mapped_sg->sgt.sgl, mapped_sg->sgt.orig_nents);
                        kfree(rxd);
+                       pr_info("%s: %d: ret=%d\n", __func__, __LINE__, ret);
                        return ret;
                }


root@j721e-evm:~# modprobe sa2ul
[   32.890801] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c
root@j721e-evm:~# [   32.981093] sa_run: 1180: temp->length: 8192, temp->offset: 0
[   32.996268] sa_run: 1180: temp->length: 8192, temp->offset: 0
[   33.002029] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.007512] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.012986] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.018458] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.023930] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.029402] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.034874] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.040345] sa_run: 1182: req->size: 40187, src: 00000000f1859ae0
[   33.046426] sa_run: 1183: sgl: 00000000f1859ae0, orig_nents: -22
[   33.052419] sa_run: 1185: ret=-22
[   33.055852] sa_run: 1180: temp->length: 8192, temp->offset: 0
[   33.061589] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.067061] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.072532] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.078004] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.083475] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.088947] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.094419] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.099890] sa_run: 1182: req->size: 32768, src: 00000000f1859ae0
[   33.105969] sa_run: 1183: sgl: 00000000f1859ae0, orig_nents: -22
[   33.111962] sa_run: 1185: ret=-22
[   33.115268] sa_run: 1180: temp->length: 8192, temp->offset: 0
[   33.121001] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.126472] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.131944] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.137416] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.142888] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.148360] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.153832] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.159304] sa_run: 1182: req->size: 34117, src: 00000000f1859ae0
[   33.165382] sa_run: 1183: sgl: 00000000f1859ae0, orig_nents: -22
[   33.171375] sa_run: 1185: ret=-22
[   33.174725] sa_run: 1180: temp->length: 8192, temp->offset: 0
[   33.180459] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.185936] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.191408] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.196879] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.202351] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.207822] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.213294] sa_run: 1180: temp->length: 0, temp->offset: 0
[   33.218765] sa_run: 1182: req->size: 31875, src: 00000000f1859ae0
[   33.224845] sa_run: 1183: sgl: 00000000f1859ae0, orig_nents: -22
[   33.230838] sa_run: 1185: ret=-22
[   33.234204] alg: ahash: sha1-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: may_sleep use_digest multibuffer(8/14/uneven) src_divs=[100.0%@alignmask+3110] dst_divs=[100.0%@+2132] key_offset=63"
[

Regards,
Manorit

> 
> Regards,
> Manorit
> 
> > Cheers,
> > -- 
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
