From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/2] crypto: KEYS: convert public key to the akcipher API
Date: Thu, 13 Aug 2015 14:56:37 +0100
Message-ID: <10314.1439474197@warthog.procyon.org.uk>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
	keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150813035433.25108.3065.stgit@tstruk-mobl1>
Content-ID: <10313.1439474197.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Can you rebase this on top of:

    http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7

David
