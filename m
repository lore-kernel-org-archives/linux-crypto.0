From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 06/18] asymmetric keys: support parsing PKCS #8 private
 key information
Date: Sun, 25 Aug 2013 18:10:12 +0200
Message-ID: <20130825161012.GC5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-7-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
	"Lee, Chun-Yi" <jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37511 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3HYQKP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Aug 2013 12:10:15 -0400
Content-Disposition: inline
In-Reply-To: <1377169317-5959-7-git-send-email-jlee@suse.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu 2013-08-22 19:01:45, Lee, Chun-Yi wrote:
> Add ASN.1 files and parser to support parsing PKCS #8 noncompressed private
> key information. It's better than direct parsing pure private key because
> PKCS #8 has a privateKeyAlgorithm to indicate the algorithm of private
> key, e.g. RSA from PKCS #1
> 
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>


> +#include <crypto/public_key.h>
> +
> +struct pkcs8_info {
> +	enum pkey_algo privkey_algo:8;		/* Private key algorithm */

Are you sure this is well-defined?

> +struct private_key_algorithm *pkcs8_private_key_algorithms[PKEY_ALGO__LAST] = {
> +	[PKEY_ALGO_DSA]         = NULL,
> +#if defined(CONFIG_PUBLIC_KEY_ALGO_RSA) || \
> +	defined(CONFIG_PUBLIC_KEY_ALGO_RSA_MODULE)
> +	[PKEY_ALGO_RSA]         = &RSA_private_key_algorithm,
> +#endif
> +};

  pkey_algo
  privkey_algo
  private_key_algorithm

...you use all variants.

Having symbols with "__" inside them is "interesting". I'd not do it.
										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
