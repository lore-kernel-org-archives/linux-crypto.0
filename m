From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RFC 0/2] crypto: Introduce Public Key Encryption API
Date: Fri, 01 May 2015 16:53:42 +0100
Message-ID: <3543.1430495622@warthog.procyon.org.uk>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, corbet@lwn.net,
	keescook@chromium.org, qat-linux@intel.com, jwboyer@redhat.com,
	richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com, vgoyal@redhat.com,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, jdelvare@suse.de,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150430223647.10157.82156.stgit@tstruk-mobl1>
Content-ID: <3541.1430495622.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> As part of the rework the enum pkey_algo has been removed as the algorithm
> to allocate will be indicated by a string - for instance "rsa" or "dsa",

No.  That number is exposed outside of the kernel.

Actually, if you can integrate:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7

then we can replace the exposed number with OIDs.

David
