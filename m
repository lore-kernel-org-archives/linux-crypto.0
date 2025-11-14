Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48B230DD0E;
	Fri, 14 Nov 2025 10:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115838; cv=none; b=dx6CMa6hEhmLPNItvJgq4FghGFYdsS4nsabtlmPq+Lf4XWaOpy5Up81X7wwN8lKm4g17NdArJI2Z/7W2FCELTWDmPCCZVg96GDh6bS1j9RK5GOAyMFGLWzXMVe8Wa7bycibVSWd1jbrrRAwKTuPU68hVoYklsvCYyHlvmPl29dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115838; c=relaxed/simple;
	bh=2bybn5eZ1ZjwqleXH2eR14bBq0pPo706+CSF2AEIKJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B00HIPJxoWD/YSF99ySHm4jWO1vJbb8GWx5+xyIcRFG2tHPSgq7KhfWfrwqKvvu6765DJU/kOut3ik/h/o5r3eVnrSgs3B7w2BcBt0M7LKUbgmtS0ums5DP1wJusDyjDyfGjyXtg84MERIk6gxLjN1d9KyZUZk8CHOv0e1gEbVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Pnv7SFIW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Pnv7SFIW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dRh3GHwftpPh46IiW5QPXttedGLKAevyQdgXM/qVNY8=; 
	b=Pnv7SFIW5P6WBDJfjtufm+ZHPt7KoGXaTqgjsULc6nMzzqAjtr19O/5xLtk8J1XxqN1Bz373BjZ
	zqJujeP5In7+TR8d0fqHgXa4R3DxvcrGdmoo+YxgRqPDGSA/yH9quQjF9ZU2gjJzD4w/ZKYALzJZj
	wk8pjXN6yKR3PXd8/YZXYOq9/WvxxlW6yQwA1KGTIlaX4sNuGLZc8uDlXLXl4TCgywRynN3depKWq
	R1aaqy7woBYtGNdj+XerfR+4lrW8b5GhVA45ilYUX8Lr1BA9h9VUkxsRLrRq8qFsztt4gzRjD+oWV
	kJQIbhdl07zEV6Z00n2umCqH/4nwyk144Rcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqxy-002yQG-0n;
	Fri, 14 Nov 2025 18:23:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:23:42 +0800
Date: Fri, 14 Nov 2025 18:23:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: syzbot <syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com>,
	daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] padata: remove __padata_list_init()
Message-ID: <aRcDLs4pxXuHnZ5p@gondor.apana.org.au>
References: <6860c5d3.a00a0220.c1739.0009.GAE@google.com>
 <68c34150.050a0220.3c6139.0045.GAE@google.com>
 <5823185b-55c6-416b-a85c-1191a045caf8@I-love.SAKURA.ne.jp>
 <aQxqTiUUrDmF5M_X@gondor.apana.org.au>
 <60778a1e-c29d-4d41-8272-9e635d9ff427@I-love.SAKURA.ne.jp>
 <aQxufVwZWwRfEaHG@gondor.apana.org.au>
 <bd67b517-fde6-4f88-be0a-d8164f3c9a72@I-love.SAKURA.ne.jp>
 <18e8dbfc-41fe-4e2d-b0f3-a86cc3270d84@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18e8dbfc-41fe-4e2d-b0f3-a86cc3270d84@I-love.SAKURA.ne.jp>

On Fri, Nov 07, 2025 at 11:49:37PM +0900, Tetsuo Handa wrote:
> syzbot is reporting possibility of deadlock due to sharing lock_class_key
> between padata_init_squeues() and padata_init_reorder_list(). This is a
> false positive, for these callers initialize different object. Unshare
> lock_class_key by embedding __padata_list_init() into these callers.
> 
> Reported-by: syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bd936ccd4339cea66e6b
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> This version might be easier to understand, for __padata_list_init() is
> cheap (which is likely inlined by compiler) and has only two callers.
> 
>  kernel/padata.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

This looks much nicer.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
