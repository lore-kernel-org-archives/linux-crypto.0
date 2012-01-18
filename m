From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 16/21] KEYS: PGP-based public key signature verification [ver #3]
Date: Wed, 18 Jan 2012 12:49:56 +0000
Message-ID: <26583.1326890996@redhat.com>
References: <CALLzPKbQb26jAqkkduSQGDDtFuNiCDf5F-HVYB-RJjF4+KLLeQ@mail.gmail.com> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184548.21874.69507.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	arjan.van.de.ven@intel.com, alan.cox@intel.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALLzPKbQb26jAqkkduSQGDDtFuNiCDf5F-HVYB-RJjF4+KLLeQ@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> Synchronous hash SHASH is used only for software hash implementation...
> HW acceleration is not supported by this hash.
> It is good for short data.
> But when calculating a hash over long data as files can be,
> async hash AHASH is a preferred choice as enables HW acceleration.

Indeed.  The asynchronous hash is a pain to use in the kernel, though, for a
couple of reasons: kernel addresses don't necessarily correspond to addresses
the h/w accel will see and you have to handle the h/w not signalling
completion.  Herbert created shash to make it easier, and for module signing,
they're perfectly sufficient.

> As in my response to [PATCH 08/21] KEYS: Add signature verification facility
> [ver #3] It would be nice to have API to pass pre-computed hash, then client
> might tackle async peculiarities by itself...

True.  If you can give me the completed hash data, then I don't need to care
how you managed it.  If you give me an uncompleted hash, I then have to deal
with the async hash in the kernel.

It might make sense for me to provide an API call to give you the postamble you
need to add to the hash to complete it.  That call could also indicate which
hash you require and could also be combined with the call to find the
appropriate key.

David
