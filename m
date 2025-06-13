Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1927027281F
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 09:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807340; cv=none; b=snZhX62kXyzbaVUdGVQnFtc+8TUAoGVS1OM5e8m4O0GmQk+qkoTeBgYXQvKPajprUb4Jlvv/Qt8mwRT1ZM89KTH7J63URmbp1OkvN/Z0hBuFwXfJO3EIyd5A8DSmW0H2UVwo0jZE6N78TnhZv+Lf/AuN9thRJrtbGRVCMU7ugDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807340; c=relaxed/simple;
	bh=nfSImx5LOos9spgPg8NpeV6PKFqtcP9k2gfZfv0BMDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPGFckxa9AgmYcIs1YQbJQX986YSOA6/sYuVw01/3KJGz50QjLHqf+OkrPj53ENxd9w1ZewFpfxEbqwTMWFe7qTqoDpSrUw/BDa9be2FesRUWfKIz7BSGjxUm4+aN9qNDvLx5nu7D4uNHoVwCeogUhdH1PiZ2sP34QPN49hKqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TqRrU/dh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TqRrU/dh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Chu8EH0uMFW2HJ37mDSpyrOjTE4dbcJr887scKhJZLI=; b=TqRrU/dhACIEkFgOGV9CCo+Foa
	rmRUKowAA/DPyToV7v+iG2KVFjVF112KYb4t+xdDoEf5YiCbHaXenTXUZOGBf8nuhBQheEpNyrEnF
	XK/ho6dwXsN51I42mZpdPpw1Xhb/bJ7PkpXvOFPmkjLn7H/mH/KjL2SXniCosJG9tYuS7uYggvqPp
	KlCplaovrhI3cqJrDA23qSkES7teWnxSBBFNbhncnzG7rHAQQtczLTyfjRAXVts7lHAgGnscVgTuE
	iXhTxIYmkAwMxXnIw+tutEg2L9k16HoCzd/CQHFkd9b7DfntCncTCBn6GRLKzDlqqwYKxQFv3t+p4
	qvkTGMSg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0ox-00CsyT-0v;
	Fri, 13 Jun 2025 17:35:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:35:35 +0800
Date: Fri, 13 Jun 2025 17:35:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - use unmanaged allocation for dc_data
Message-ID: <aEvw58tK7nlqWD9O@gondor.apana.org.au>
References: <20250522082141.3726551-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522082141.3726551-1-suman.kumar.chakraborty@intel.com>

On Thu, May 22, 2025 at 09:21:41AM +0100, Suman Kumar Chakraborty wrote:
> The dc_data structure holds data required for handling compression
> operations, such as overflow buffers. In this context, the use of
> managed memory allocation APIs (devm_kzalloc() and devm_kfree())
> is not necessary, as these data structures are freed and
> re-allocated when a device is restarted in adf_dev_down() and
> adf_dev_up().
> 
> Additionally, managed APIs automatically handle memory cleanup when the
> device is detached, which can lead to conflicts with manual cleanup
> processes. Specifically, if a device driver invokes the adf_dev_down()
> function as part of the cleanup registered with
> devm_add_action_or_reset(), it may attempt to free memory that is also
> managed by the device's resource management system, potentially leading
> to a double-free.
> 
> This might result in a warning similar to the following when unloading
> the device specific driver, for example qat_6xxx.ko:
> 
>     qat_free_dc_data+0x4f/0x60 [intel_qat]
>     qat_compression_event_handler+0x3d/0x1d0 [intel_qat]
>     adf_dev_shutdown+0x6d/0x1a0 [intel_qat]
>     adf_dev_down+0x32/0x50 [intel_qat]
>     devres_release_all+0xb8/0x110
>     device_unbind_cleanup+0xe/0x70
>     device_release_driver_internal+0x1c1/0x200
>     driver_detach+0x48/0x90
>     bus_remove_driver+0x74/0xf0
>     pci_unregister_driver+0x2e/0xb0
> 
> Use unmanaged memory allocation APIs (kzalloc_node() and kfree()) for
> the dc_data structure. This ensures that memory is explicitly allocated
> and freed under the control of the driver code, preventing manual
> deallocation from interfering with automatic cleanup.
> 
> Fixes: 1198ae56c9a5 ("crypto: qat - expose deflate through acomp api for QAT GEN2")
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_compression.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
