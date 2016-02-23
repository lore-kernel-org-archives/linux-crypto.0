From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto layer
Date: Tue, 23 Feb 2016 10:53:19 +0000
Message-ID: <12559.1456224799@warthog.procyon.org.uk>
References: <56CB9B34.20902@intel.com> <56CB68A2.50505@intel.com> <20160219171806.17223.91381.stgit@warthog.procyon.org.uk> <20160219171836.17223.9507.stgit@warthog.procyon.org.uk> <1562.1456180090@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56CB9B34.20902@intel.com>
Content-ID: <12558.1456224799.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> > Ummm...  Possibly.  Is that how it's used?
> > 
> > 	warthog>git grep pkcs1pad -- Documentation
> > 	warthog1>
> 
> Yes, no docs. Sorry.

Can I suggest you at least stick a quick usage summary in the banner comment
at the top of the file?

> > Anyway, the problem I have with this is that I want to get that knowledge
> > out of the asymmetric key in-software public key subtype.  It knows "rsa",
> > "dsa", "ecdsa", ... because that's all the OIDs tell it.
> 
> Rigth, for now the public_key would need to build the full algorithm string as
> follows:
> 
> vsprintf(name, "pkcs1pad(%s, %s)", pkey_algo_name[sig->pkey_algo],
>          hash_algo_name[sig->pkey_hash_algo]);

Does this apply to anything other than RSA?

> Do you plan to add more padding schemes later? 

No plans to, but one never knows.  I'm *assuming* that OID_rsaEncryption and
OID_sha256WithRSAEncryption, for example, must implicitly specify the padding
scheme (RFC4055 suggests I'm right in this assumption).

We might have to suppose RSASSA-SSP at some point.

> Yes, I can start woring on a subsequent patch based on your changes in
> http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-rsa
> Is that ok with you?

Sure.

David
