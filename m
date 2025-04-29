Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949E1DE8B2;
	Tue, 29 Apr 2025 05:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745906086; cv=none; b=RMRQJZMlRW/uekul2CJNMzOGa4s0rwbijMcKLy2xGylkLa72YaP2rBjmfUsMnEk9v5e4tMsrXQkme13uJGcy+EhVLd140QK8UjUshy8qtSQdYHZdstbya0OCVv1wKh8949aj+fzxRql1hSgRS5vcagaRpqwufvcuHYUwkVQTwH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745906086; c=relaxed/simple;
	bh=nb+nYwrAgyj/eqxrYtpAH90jouJToyN/XaNbYT+bYXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZjMqhLIBUUuAvE9LhIIP1uE+IdaguGJshNtOVhihkFbMkgeywQZZxgRkI2HSzxTWzMRAlNF+rXSHyI+qokLrLyTpljSHVTiCeZHS/Kmq9lE/Vkyu9v5zvtYJ+QhGoxjLiptU4SgXmpXPvn+Te9fX2+NUBilaUEBwY2IBtMMYcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2desh9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2desh9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9EEC4CEE3;
	Tue, 29 Apr 2025 05:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745906085;
	bh=nb+nYwrAgyj/eqxrYtpAH90jouJToyN/XaNbYT+bYXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j2desh9hc8fSy74ecVOLk4Y/lCsVOGGJK+3KCZqtCWbnMU8BaOyaofa4wCvjtKYqu
	 GIqywQRYwaFnjoBhbwfWh//LwZ0KGTOJgR71MS3YHnlZ3DfII6wIRzqfSDdGXPeGoQ
	 vwPIKOntjnKNAITU/Ah2woAv+l5vTZjqdw1LSxVI=
Date: Tue, 29 Apr 2025 07:54:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Russ Weight <russ.weight@linux.dev>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Amadeusz =?utf-8?B?U8WCYXdpxYRza2k=?= <amadeuszx.slawinski@linux.intel.com>
Subject: Re: [PATCH] firmware_loader: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <2025042935-ethanol-remodeler-bf69@gregkh>
References: <20250428190909.852705-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428190909.852705-1-ebiggers@kernel.org>

On Mon, Apr 28, 2025 at 12:09:09PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This user of SHA-256 does not support any other algorithm, so the
> crypto_shash abstraction provides no value.  Just use the SHA-256
> library API instead, which is much simpler and easier to use.
> 
> Also take advantage of printk's built-in hex conversion using %*phN.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This patch is targeting the firmware_loader tree for 6.16.


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
