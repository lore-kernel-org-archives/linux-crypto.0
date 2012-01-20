From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver
	#3]
Date: Fri, 20 Jan 2012 12:52:51 +1100
Message-ID: <20120120015251.GA8436@gondor.apana.org.au>
References: <31888.1326916778@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dmitry.kasatkin@intel.com, dhowells@redhat.com,
	keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	arjan.van.de.ven@intel.com, alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31888.1326916778@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Howells <dhowells@redhat.com> wrote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
> 
>> I thought about export/import.
>> But I think export/Import is hash driver implementation specific...
>> Cannot use ahash state for shash...
> 
> Yeah...  I'll have to consult Herbert Xu about that.

export/import is meant to be work across implementations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
