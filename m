From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Fri, 28 Sep 2012 15:25:17 +0930
Message-ID: <87r4pm3d4q.fsf@rustcorp.com.au>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16088.1348736905@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Hi Rusty,
>
> Could you pull my tree?
>
> David
> ---
>
> The following changes since commit eeea3ac912207dcf759b95b2b4c36f96bce583bf:
>
>   Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-09-06 10:23:58 -0700)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git modsign-post-KS
>
> for you to fetch changes up to 15765081423824e1ccc329264ae13f5ea87f3a85:
>
>   MODSIGN: Sign modules during the build process (2012-09-26 10:11:06 +0100)

warning: (MODULE_SIG) selects ASYMMETRIC_KEY_TYPE which has unmet direct dependencies (CRYPTO && KEYS)

Ah, I see:

+	select CONFIG_KEYS
+	select CONFIG_CRYPTO

I fixed this commit, rather than go around again.

Thanks,
Rusty.
