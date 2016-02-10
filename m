From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v5 1/3] crypto: KEYS: convert public key and digsig asym to the akcipher api
Date: Wed, 10 Feb 2016 14:17:56 +0000
Message-ID: <5286.1455113876@warthog.procyon.org.uk>
References: <20160202180853.2887.82271.stgit@tstruk-mobl1> <20160202180848.2887.9937.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160202180853.2887.82271.stgit@tstruk-mobl1>
Content-ID: <5285.1455113876.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Why didn't you put the RSA signature parsing - ie. where the OID and the other
bits are checked - into crypto/rsa.c?

David
