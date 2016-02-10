From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v5 1/3] crypto: KEYS: convert public key and digsig asym
 to the akcipher api
Date: Wed, 10 Feb 2016 15:09:21 -0800
Message-ID: <56BBC321.1000503@intel.com>
References: <20160202180853.2887.82271.stgit@tstruk-mobl1>
 <20160202180848.2887.9937.stgit@tstruk-mobl1>
 <5286.1455113876@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5286.1455113876@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,
On 02/10/2016 06:17 AM, David Howells wrote:
> Why didn't you put the RSA signature parsing - ie. where the OID and the other
> bits are checked - into crypto/rsa.c?
> 

Do you want to get rid of the crypto/asymmetric_keys/rsa.c completely?
I wanted to make the conversion churn as small as possible.
I can move it in a subsequent patch if you want.
Thanks,
-- 
TS
