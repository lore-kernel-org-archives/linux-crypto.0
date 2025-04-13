Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01A91E9B28;
	Sun, 13 Apr 2025 18:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744570377; cv=none; b=RcJkCfr2ryGLuen+/cDmOoOac6G4+nuUFAJD3sgZzms8YQRWhqcMQAyDxlA8bF+/cBqJBKfFOcVjCMo6b4uzbY6df6GwUi9+r2UdgJ8F94CxNsk8YNvKErDFyAHB3/4gkIyDenzk8r4lE7ev7l8h0NDSr/7/sm6iVry872S+UQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744570377; c=relaxed/simple;
	bh=s/+mRWdw9tTO792IvfwClf62fm5f6rXE+fkX7LgWjBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2Un99IqvULE/JGBHgqSSTwR6h/3QxlkxLSqMDXnYQqaLc53XTlL7o05gFPJ6rrMnIi7eAfmCMaruoB3xy6rCJOCws6rbzCl4ZBg1bkPYl+33Fq4okwRbuGKbKIlBpxPJuHhwe02GNKldeEQbd8e7ogsMe3An2ol83SlANQtbs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 637F32C06E2F;
	Sun, 13 Apr 2025 20:52:10 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 307474555F; Sun, 13 Apr 2025 20:52:46 +0200 (CEST)
Date: Sun, 13 Apr 2025 20:52:46 +0200
From: Lukas Wunner <lukas@wunner.de>
To: "Gupta, Nipun" <nipun.gupta@amd.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, herbert@gondor.apana.org.au,
	davem@davemloft.net, dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	krzk+dt@kernel.org, gregkh@linuxfoundation.org, robh@kernel.org,
	conor+dt@kernel.org, ogabbay@kernel.org,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
	derek.kiernan@amd.com, dragan.cvetic@amd.com, arnd@arndb.de,
	praveen.jain@amd.com, harpreet.anand@amd.com,
	nikhil.agarwal@amd.com, srivatsa@csail.mit.edu, code@tyhicks.com,
	ptsm@linux.microsoft.com, linux-crypto@vger.kernel.org,
	Ignat Korchagin <ignat@cloudflare.com>,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/3] accel/amdpk: add driver for AMD PKI accelerator
Message-ID: <Z_wH_uCx558T0__c@wunner.de>
References: <20250409173033.2261755-1-nipun.gupta@amd.com>
 <20250409173033.2261755-2-nipun.gupta@amd.com>
 <20250410-sly-inventive-squirrel-ddecbc@shite>
 <bf851be7-74a5-8f9d-375b-b617691b6765@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf851be7-74a5-8f9d-375b-b617691b6765@amd.com>

On Fri, Apr 11, 2025 at 10:21:03AM +0530, Gupta, Nipun wrote:
> On 10-04-2025 13:06, Krzysztof Kozlowski wrote:
> > On Wed, Apr 09, 2025 at 11:00:32PM GMT, Nipun Gupta wrote:
> > > The AMD PKI accelerator driver provides a accel interface to interact
> > > with the device for offloading and accelerating asymmetric crypto
> > > operations.
> > > 
> > 
> > For me this is clearly a crypto driver and you are supposed to:
> > 1. Cc crypto maintaners,
> > 2. Put it actually into crypto and use crypto API.
> 
> added crypto maintainers for comments.
> IMO, as accel framework is designed to support any type of compute
> accelerators, the PKI crypto accelerator in accel framework is not
> completely out of place here, as also suggested at:
> https://lore.kernel.org/all/2025031352-gyration-deceit-5563@gregkh/

To be fair, Greg did suggest drivers/crypto/ as an alternative... :)

  "Great, then why isn't this in drivers/accel/ or drivers/crypto/ ?"
  https://lore.kernel.org/r/2025031236-siamese-graffiti-5b98@gregkh/

There are already six drivers for crypto accelerators in drivers/crypto/,
so that would seem to be a natural fit for your driver:

  aspeed/aspeed-acry.c
  caam/caampkc.c
  ccp/ccp-crypto-rsa.c                 <-- from AMD no less!
  hisilicon/hpre/hpre_crypto.c
  intel/qat/qat_common/qat_asym_algs.c
  starfive/jh7110-rsa.c

You can find these in the tree with:

  git grep 'cra_name = "rsa"'

So far there are only drivers to accelerate RSA encryption/decryption.
The kernel supports a single padding scheme, PKCS1, which is implemented
by crypto/rsa-pkcs1pad.c.  There is no support yet for OAEP.

So the padding of the hash (which is cheap) happens in software and then
crypto/rsa-pkcs1pad.c performs an RSA encrypt/decrypt operation which is
either performed in software by crypto/rsa.c, or in hardware if a crypto
accelerator is present.  Drivers for crypto accelerators register the
"rsa" algorithm with a higher cra_priority than the software
implementation, hence are generally preferred.

One benefit that you get from implementing a proper akcipher_alg in your
driver is that virtual machines may take advantage of the hardware
accelerator through the virtio support implemented by:
drivers/crypto/virtio/virtio_crypto_akcipher_algs.c

Note that the crypto subsystem currently does not support hardware
acceleration of signature generation/verification (crypto_sig),
but only encryption/decryption (crypto_akcipher).  One reason is
that signature generation/verification is generally a synchronous
operation and doesn't benefit as much from hardware acceleration
due to the overhead of interacting with the hardware.

So there's no support e.g. for generating or verifying ECDSA signatures
in hardware.  I think that would only really make sense if private keys
are kept in hardware and cannot be retrieved.  So the use case wouldn't
be acceleration, but security of private keys.

That said, for RSA specifically, signature generation/verification does
involve an encrypt/decrypt operation internally.  The padding is once
again done in software (by crypto/rsassa-pkcs1.c -- no PSS support yet).
But the actual encrypt/decrypt operation will be performed in
hardware if a crypto accelerator is present.

The user space interface Herbert referred to is a set of system calls
which are usable e.g. via the keyutils library and command line utility:
https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/

HTH,

Lukas
