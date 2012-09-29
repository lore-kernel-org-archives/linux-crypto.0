From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Sat, 29 Sep 2012 16:23:31 +0930
Message-ID: <87wqzdnwus.fsf@rustcorp.com.au>
References: <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <27378.1348819793@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> And after those three fixes, I still get all fail:
>> 
>> [    3.361036] Request for unknown module key 'Magrathea: Glacier signing key: 6
>> e03943da0f3b015ba6ed7f5e0cac4fe48680994' err -11
>
> Can you look back further in your kernel output, see if you can spot the bit
> where it's trying to load the keys.  Look for things from modsign_pubkey.c:
>
> 	pr_notice("Loading module verification certificates\n");
> 	...
> 			pr_err("MODSIGN: Problem loading in-kernel X.509 certificate (%ld)\n",
> 			       PTR_ERR(key));
> 		else
> 			pr_notice("MODSIGN: Loaded cert '%s'\n",
> 				  key_ref_to_ptr(key)->description);
>
>> CONFIG_CRYPTO_SHA1=m
>
> Hmmm...  I suspect it's that.  We need a hash to verify the key's own
> signature too - and if you're using the key my autogen patch created for you,
> I think that would be SHA1, so that must be built in too.

Right, I chose SHA-512 because everyone knows it's 512 times more secure
than SHA-1.

I cherry-picked those two patches, and now I see:

[    2.808075] Loading module verification certificates
[    2.809331] X.509: Cert 6e03943da0f3b015ba6ed7f5e0cac4fe48680994 has expired
[    2.810500] MODSIGN: Problem loading in-kernel X.509 certificate (-127)

I noticed the Cert number didn't change with rebuilds: "distclean"
didn't remove some files:

$ git clean -f -f -x -d
Removing extra_certificates
Removing signing_key.priv
Removing signing_key.x509
Removing signing_key.x509.keyid
Removing signing_key.x509.signer
Removing x509.genkey

Removing them didn't fix it either, but at least I got a new certificate.

This is x86-32 BTW.  I've put the complete, built tree (minus .git dir)
up at http://ozlabs.org/~rusty/linux-for-dhowells.tar.xz

Here's how I run it:
kvm -nographic -m 256 -net user,restrict=off -net nic,model=virtio -drive file=$QEMUIMAGE,index=0,media=disk,if=virtio -drive file=$QEMUIMAGEB,index=1,media=disk,if=virtio -kernel arch/x86/boot/bzImage -append "ro root=/dev/vda1 console=ttyS0 $*"

Thanks,
Rusty.
