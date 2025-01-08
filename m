Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8FE1FF1B8
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jan 2025 16:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736354031; cv=none; b=rQDQ5FYwKq46JeD+jSbHF9f9Zh7I2yB4wIT5xR8vWNUwU7dQKCR0LMwP5hU2T0GgJsjgv4Dfvp0FltsfEmmPgm6p3Kx8my15pwycsluzMV3Lz3hmtkqjIP2tyBeou6KmJLtkzQpYJELVsy42mhv6QOwRzNakvIJ39bjRNL9BpRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736354031; c=relaxed/simple;
	bh=KaRQXQ4B5Tuxsxer6kznfKUePfs6oG6NI2zxhJzX4wM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reMBYFl+sqAQwiaxp3iqlgtvoClhYDsxLyqZbSGWDVmkg722Yqj4xflUBwpNUjEQBC5uE8CzL8iyFCSSRYo0c+zL+r7oxCsph+5wa7bqY1AQ5qgh2D7Aw8uFGDHtDhE1L/6dxzPpIg827GjnZAsnAQR2hwEZ9LuT8XGxGN6rYRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2hstfDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2hstfDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72C8C4CEDD;
	Wed,  8 Jan 2025 16:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736354031;
	bh=KaRQXQ4B5Tuxsxer6kznfKUePfs6oG6NI2zxhJzX4wM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c2hstfDr1LfQgz2aucHCs4EBfPC5X4VJYmL7XUiRa1llh5AX+IjtroeTQLVxBXq1M
	 G5bL7yk7zMnXJ74vDM2prMa2fSiB5k/tL5cIFpWjzjd+mFvCcditbaspSxn/Lc9++l
	 pbyx4WcfNk824lJ+NuvOeXvXHIE4nn6o3JSrjtIz9GdAULaDOI0Vc7vbE5ZkOCauaZ
	 +BSTmPnewrk5xPSRBCHoOw/Zx9Bo8ajKtP6htUj76cCCNOEdSH1clxHvixrR5XcFGj
	 i8c2nSegL4fO0vy5zQO29kduR/Sv8+E9We0gkbVKhVgjrw3O5DT5gDDF+WguqW/81G
	 5ss9eXCAqPAQg==
Date: Wed, 8 Jan 2025 09:33:48 -0700
From: Keith Busch <kbusch@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org, Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 09/10] nvmet-tcp: support secure channel concatenation
Message-ID: <Z36o7IqZnwkuckwF@kbusch-mbp>
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-11-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203110238.128630-11-hare@kernel.org>

On Tue, Dec 03, 2024 at 12:02:37PM +0100, Hannes Reinecke wrote:
> Evaluate the SC_C flag during DH-CHAP-HMAC negotiation and insert
> the generated PSK once negotiation has finished.

...

> @@ -251,7 +267,7 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
>  
>  	uuid_copy(&ctrl->hostid, &d->hostid);
>  
> -	dhchap_status = nvmet_setup_auth(ctrl);
> +	dhchap_status = nvmet_setup_auth(ctrl, req);
>  	if (dhchap_status) {
>  		pr_err("Failed to setup authentication, dhchap status %u\n",
>  		       dhchap_status);
> @@ -269,12 +285,13 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
>  		goto out;
>  	}

This one had some merge conflicts after applying the pci endpoint
series from Damien. I tried to resolve it, the result is here:

  https://git.infradead.org/?p=nvme.git;a=commitdiff;h=11cb42c0f4f4450b325e38c8f0f7d77f5e1a0eb0

The main conflict was from moving the nvmet_setup_auth() call from
nvmet_execute_admin_connect() to nvmet_alloc_ctrl().
