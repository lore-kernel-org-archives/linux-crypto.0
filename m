Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034EC29A1;
	Mon, 26 May 2025 02:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748225818; cv=none; b=QKIfui8KGom/CLB43dbmt/ePzcSxT8mfta3l/huFozJpLZd+iFR5LuDw/r67gAcHTv2jdURRXBbIJ5ocva24csaJ3KzMvUnIfqtyY1fbl0kHctgFKEbylw99b/XGbZVnHMJSyj55aJbniu/sT2KAuRljvWNHeG6f+y2XNBtE1Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748225818; c=relaxed/simple;
	bh=EYFyMr0Y/R5g9sFPe7DAtm3hbt3TtZaWfEFRhVHMnJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNzz+CgivQVKSIQQNZ91qN0F9u/S4FtCvPuh/NqLB+eg11/PF2bjK+tHpX9DsXYA3lMLynRuMCGXEfCfXBPeNsQjwde873Sv91xY2xYT+o2uzFFMd8cRUlNotMm1x+BFOhhhPCwMdq9wa1fkHLCS+ThqWXfAjkyEeofFOudyKRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OwCD5HHL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OwCD5HHL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ly2ecRcvwo7NqOtah69RwHLedx/XOXIh6rAJ+raLY4I=; b=OwCD5HHLaXEdok/bLtpEuqazC8
	CbMt1DBITTDterATyV109GAPcQHeq27XRYDz29jJ8vTAVDS42O1S8LCDAu2t/VNbVWcyJtN4aUOCj
	iz96N3E9OFbsEtbQKGl/kxge1Nns3bM1+3heNWVD79JghBjvpOd23wfI2ztvivA1TCLtpcisXkPqP
	NC4j0XuhgmHwmIFUppIWPnYX0rwXYh5DDICLHDOQ2LpneSxf1ve3BCRSf3OsVnkqc2YR5ZO/G1b+r
	SwYgtx13x+8GofBymcpK6LZx+vG4Xkxyx3Cib0bJqj32LjrDtHIcZvR6DGZvsEA83gmlrEM3aEMr4
	joCqI7Zw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uJNO7-008wjr-1J;
	Mon, 26 May 2025 10:16:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 May 2025 10:16:27 +0800
Date: Mon, 26 May 2025 10:16:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	nstange@suse.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: Re: [PATCH v2 3/3] padata: avoid UAF for reorder_work
Message-ID: <aDPO-9j83gUg-eMg@gondor.apana.org.au>
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
 <20250110061639.1280907-4-chenridong@huaweicloud.com>
 <aC_yoWXJcsLxfLR4@gondor.apana.org.au>
 <faa23d11-4387-4952-bd29-034b4558668c@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faa23d11-4387-4952-bd29-034b4558668c@huaweicloud.com>

On Mon, May 26, 2025 at 09:15:37AM +0800, Chen Ridong wrote:
>
> Unfortunately, I did not reproduce this bug, It was mentioned:
> https://lore.kernel.org/all/20221019083708.27138-6-nstange@suse.de/
> 
> We through that the kworker is asynchronous, and this scenarios may happen.

Right.  I think the only way this can happen is through padata_replace.
That is indeed completely asynchronous and must be guarded against
using the reference count.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
