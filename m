From: Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [RFC crypto v3 0/9] Chelsio Inline TLS
Date: Sun, 21 Jan 2018 23:16:02 +0100
Message-ID: <20180121221602.GA527@bistromath.localdomain>
References: <1513769582-25786-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        ganeshgr@chelsio.com, netdev@vger.kernel.org, davem@davemloft.net,
        davejwatson@fb.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513769582-25786-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2017-12-20, 17:03:02 +0530, Atul Gupta wrote:
> RFC series for Chelsio Inline TLS driver (chtls.ko)
> 
> Driver use the ULP infrastructure to register chtls as Inline TLS ULP.

I don't think drivers should be registering their own ULP. TLS
offloading should be transparent to userspace, whatever HW ends up
being used. If each driver implements its own ULP, the application has
to be aware of what HW and what driver it's running on.

I think this offload should rely on a generic infrastructure, not
build its own private interface. Look at the current kTLS code, the
proposal for an offload infrastructure [0] from Mellanox, and see how
you can fit your driver into that, and extend what's missing.

[0] https://patchwork.ozlabs.org/patch/849984/


[...]
> Atul Gupta (9):
>   chtls: structure and macro definiton
>   cxgb4: Inline TLS FW Interface
>   cxgb4: LLD driver changes to enable TLS
>   chcr: Key Macro
>   chtls: Key program
>   chtls: CPL handler definition
>   chtls: Inline crypto request Tx/Rx
>   chtls: Register the ULP
>   Makefile Kconfig

That patchset is split so that each patch touches a separate set of
files, and the description of the contents of each patch is very
limited.  Can you try to group your changes by feature instead?  That
should help you come up with descriptive commit messages as well.


Thanks,

-- 
Sabrina
