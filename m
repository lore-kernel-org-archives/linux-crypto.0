Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3012DCBE7;
	Fri, 23 May 2025 03:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747972147; cv=none; b=VnjRccYUVGl2rkZfGvTCkCZpVL6bzTCucTmWNy1KpRRFK+bBKLqUDu6xy3InPoXW8MQLTmp+wOrha/9T+X5iR/yF25pC9nifN9FbnpX9xFYFGQ/6smr6SXZ7Ys8jt/toF96xDmVgnRclUrxSDv3KUE/evW5OTODmKqr1lFyT3Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747972147; c=relaxed/simple;
	bh=oCkTUZ7+Y7bhVatNM2RfHr6M2r+SRjCNZylmZL6UJFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QepwIQtPdVXl0P3D+U4F3zpVibImk5FJ4tpWVHLoZfdM+LJD888w9JnD03Jg5t2M2L81bFzPrK9GB2+Vn9NFfrTrhTAKkp3WDIPxyBAy3l8ixORSwr+klyaCrWv82sB55SpiOLbmtUCZfj/7GpuF/i8AsM2khbxQ2ECReb5NA3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=s2wKQVN6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="s2wKQVN6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MgC3u1CSlJS3gOFGAUphVv99r7Zue3/JLw+CDbKhaIc=; b=s2wKQVN6C8xXm7ivqSOzSq6T2G
	aZhWkJWaGNT67G0iEAFjesBPZTYSYA/tGNnVaXkYjvpXGaKHX0JAOQylpkgNHJpXFU1RqMHEcqP1r
	sVY2OEnkxClzmELLTSITSlb/PZoMroJuH5glU4wVI15taa5XwclZsONAe2LscZ9mzQHu9gdSDXtbx
	d+hHWyJgjezojmtTWt7dpJPWhx4Nsa+DicRRVrQFVtWo0SGwYmaNQCc4VPknztwe/9oZedHm1EdES
	Xl9ggJ0K8OiMYk9EIkYFYxR0/N2NV/smtXIqic9yPSSMzD6PnBMtvsE17T31NAZipfS4y+/Ug2NDh
	2UOwvqmw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIJOj-008GAk-0P;
	Fri, 23 May 2025 11:48:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 11:48:41 +0800
Date: Fri, 23 May 2025 11:48:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aishwarya <aishwarya.tcv@arm.com>
Cc: dominik.grzegorzek@oracle.com, chenridong@huawei.com,
	daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, steffen.klassert@secunet.com,
	broonie@kernel.org
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
Message-ID: <aC_wGV_rc1JP06to@gondor.apana.org.au>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
 <20250522131041.8917-1-aishwarya.tcv@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522131041.8917-1-aishwarya.tcv@arm.com>

On Thu, May 22, 2025 at 02:10:41PM +0100, Aishwarya wrote:
>
> A bisect identified this patch as introducing the failure. Bisected
> it on the tag "v6.15-rc7-7-g4a95bc121ccd" at repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

What if you revert the patch in question as well as the one it
was supposed to fix, i.e., commit dd7d37ccf6b1 ("padata: avoid
UAF for reorder_work")? I've attached both reverts together as
a patch.

I think the original fix was broken since the bug is actually
in the Crypto API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/kernel/padata.c b/kernel/padata.c
index 7eee94166357..e0af15779d80 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -352,15 +352,8 @@ static void padata_reorder(struct parallel_data *pd)
 	smp_mb();
 
 	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
-	if (!list_empty(&reorder->list) && padata_find_next(pd, false)) {
-		/*
-		 * Other context(eg. the padata_serial_worker) can finish the request.
-		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
-		 */
-		padata_get_pd(pd);
-		if (!queue_work(pinst->serial_wq, &pd->reorder_work))
-			padata_put_pd(pd);
-	}
+	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
+		queue_work(pinst->serial_wq, &pd->reorder_work);
 }
 
 static void invoke_padata_reorder(struct work_struct *work)
@@ -371,8 +364,6 @@ static void invoke_padata_reorder(struct work_struct *work)
 	pd = container_of(work, struct parallel_data, reorder_work);
 	padata_reorder(pd);
 	local_bh_enable();
-	/* Pairs with putting the reorder_work in the serial_wq */
-	padata_put_pd(pd);
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
