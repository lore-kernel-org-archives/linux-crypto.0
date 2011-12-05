From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Subject: Re: [RFC][PATCH 00/16] Crypto keys and module signing [ver #2]
Date: Mon, 05 Dec 2011 03:32:13 -0800
Message-ID: <4EDCABBD.9020401@intel.com>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11/29/2011 03:42 PM, David Howells wrote:
> 
> I have provided a couple of subtypes: DSA and RSA.  Both types have signature
> verification facilities available within the kernel, and both can be used for
> module signature verification with any encryption algorithm known by the PGP
> parser, provided the appropriate algorithm is compiled directly into the
> kernel.
> 

Do we really need the complexity of a full OpenPGP parser?  Parsers are
notorious security problems.  Furthermore, using DSA in anything but a
hard legacy application is not something you want to encourage, so why
support DSA?

	-hpa
