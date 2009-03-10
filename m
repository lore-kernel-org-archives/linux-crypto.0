From: David Miller <davem@davemloft.net>
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
Date: Tue, 10 Mar 2009 13:17:00 -0700 (PDT)
Message-ID: <20090310.131700.40129006.davem@davemloft.net>
References: <49B6B821.5050302@oracle.com>
	<10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com>
	<49B6C8BF.8010105@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: geert@linux-m68k.org, sfr@canb.auug.org.au,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: randy.dunlap@oracle.com
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <49B6C8BF.8010105@oracle.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 10 Mar 2009 13:08:31 -0700

> I'll have to let David or Herbert answer that.  From my quick look
> at the code, I don't see much use for nlattr.c when CONFIG_NET
> is not enabled.

We want to use the netlink attribute parsers even in non-networking
code, that's what he's trying to do here.
