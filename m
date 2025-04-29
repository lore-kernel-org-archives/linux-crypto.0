Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C07E242D6E;
	Tue, 29 Apr 2025 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745944946; cv=none; b=sGyXXuCDWSOshyrtVnv5BLnmxA4hw3fDLh1a3BGAQTpvZi1JHktAOMtchybRtKlDejGzYobLkxEfqjJ+9JgSMSUlLJ4zHr1Jv68FO5XO8qcNKoDvtt2xkG5KpEsB9p5r9cHDbFDvmYXbPqZmJS+GQtDYSJLXsRB+xlsDEF91vFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745944946; c=relaxed/simple;
	bh=ubCQ+1nz/UrnwBW5+P/ki1szuiGWwSLpS0BipGSViPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K11qJDygB4Nv7Dq9xwRBv5qwM02Ooa3itrKLAlCDoAmCR0Z6IfbmuDUD4CR4qEANi+Tn40XbHCI2jT0pa8pG2jWq59AvbIdMWR+7rEw8igNp6B9t5AkIRj/h9RbQcUoifpYalAPAusMIgbockNIUiY54UQwBnwMSs3fUi4UaQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSZAwrAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSZAwrAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356CCC4CEE3;
	Tue, 29 Apr 2025 16:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745944945;
	bh=ubCQ+1nz/UrnwBW5+P/ki1szuiGWwSLpS0BipGSViPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BSZAwrAL8nk18eoJTfmYkZwRh761GC4sL86Xdd4xSSeJooZtIwdH9ppNdrTKnrCNM
	 m5tFwHimiws9PqkG/S7muSBLpwXrMVVTLNIA0tszpTF1DIfoSrH1JNrJEJXTRg5VRd
	 VSAAmlU19ZRT/2CC+vGWlP784Itcdb0g1HESbAB1r/sgz0268peS95zCYxt/hPhVaQ
	 x3oJbYKD0k4lmgnAyLGsShDWVI9kj0d3A6aYaCsn+uC5ZL/PIEh5D4fiVYgqSSkuXj
	 O6PYQWbqw+d59CjTMX8JmoD8508dIhVPb20rK1eNcLTauEEN/muv3AURikZdih/4C2
	 iIOAXk4cexscA==
Date: Tue, 29 Apr 2025 09:42:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Russ Weight <russ.weight@linux.dev>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Amadeusz =?utf-8?B?U8WCYXdpxYRza2k=?= <amadeuszx.slawinski@linux.intel.com>
Subject: Re: [PATCH] firmware_loader: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <20250429164223.GB1743@sol.localdomain>
References: <20250428190909.852705-1-ebiggers@kernel.org>
 <2025042935-ethanol-remodeler-bf69@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025042935-ethanol-remodeler-bf69@gregkh>

On Tue, Apr 29, 2025 at 07:54:42AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Apr 28, 2025 at 12:09:09PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > This user of SHA-256 does not support any other algorithm, so the
> > crypto_shash abstraction provides no value.  Just use the SHA-256
> > library API instead, which is much simpler and easier to use.
> > 
> > Also take advantage of printk's built-in hex conversion using %*phN.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > This patch is targeting the firmware_loader tree for 6.16.
> 
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg, it looks like you normally take patches to this file.  You can go ahead
and take it if you want.  Thanks!

- Eric
