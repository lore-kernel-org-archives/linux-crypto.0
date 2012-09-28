From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Fri, 28 Sep 2012 09:13:09 +0100
Message-ID: <27465.1348819989@warthog.procyon.org.uk>
References: <87r4pm3d4q.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <87r4pm3d4q.fsf@rustcorp.com.au>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> warning: (MODULE_SIG) selects ASYMMETRIC_KEY_TYPE which has unmet direct dependencies (CRYPTO && KEYS)
> 
> Ah, I see:
> 
> +	select CONFIG_KEYS
> +	select CONFIG_CRYPTO
> 
> I fixed this commit, rather than go around again.

Thanks.

select is irritatingly broken in that regard.

David
