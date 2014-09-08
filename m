From: Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
Date: Mon, 08 Sep 2014 15:47:52 -0500
Message-ID: <540E15F8.2030900@converseincode.com>
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com>	 <alpine.DEB.2.10.1409060131260.5472@nanos>	 <540A590F.1030407@converseincode.com>	 <alpine.DEB.2.10.1409061152090.5472@nanos>	 <540BBD9E.6050708@converseincode.com> <540D73C9.3000906@samsung.com>	 <540DA051.2030701@converseincode.com> <1410183821.8054.27.camel@dhcp-9-2-203-236.watson.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	james.l.morris@oracle.com, linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, serge@hallyn.com,
	torvalds@linux-foundation.org,
	Mark Charlebois <charlebm@gmail.com>,
	=?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1410183821.8054.27.camel@dhcp-9-2-203-236.watson.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/08/14 08:43, Mimi Zohar wrote:
>
> Behan, thank you for the explanation.
No worries. I should have explained better. My apologies.

> The same snippet of code used
> here, and elsewhere in the kernel, is taken from the crypto subsystem.
> Once it is resolved in the crypto subsystem, the same solution should be
> propogated.
>
> Mimi
Indeed that is my intention. I have tglx's suggested solution coded 
already. Just doing a bunch of allyesconfig builds to confirm all is 
compiling correctly.

I will post all patches as a single patch set this time (posted to all 
concerned).

I will repeat the explanation as well with the new patch set so everyone 
else in other subsystems sees those reasons as well.

If this works for everyone I'll also go back and update the crypto 
patches for the subsystems that have already accepted my previous patches.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

