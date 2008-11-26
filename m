From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
Date: Tue, 25 Nov 2008 17:08:51 -0800 (PST)
Message-ID: <20081125.170851.97706149.davem@davemloft.net>
References: <20081125085820.GA11401@elte.hu>
	<20081125152014.GB29096@gondor.apana.org.au>
	<20081125171438.GK22504@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: mingo@elte.hu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35737
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbYKZBIv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 20:08:51 -0500
In-Reply-To: <20081125171438.GK22504@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Nov 2008 18:14:38 +0100

>     fix warning in drivers/net/s2io.c
>     fix warnings in drivers/net/niu.c
>     fix warning in drivers/net/niu.c
>     fix warning in drivers/net/qla3xxx.c
>     fix warning in net/sunrpc/xprtrdma/svc_rdma_transport.c
>     fix warning in net/sched/sch_hfsc.c

Applied.

>     fix warning in net/netfilter/nf_conntrack_ftp.c

Patrick got this one.

>     fix warning in net/ipv6/ip6_flowlabel.c
>     fix warning in net/dsa/mv88e6xxx.c
>     fix warning in net/dsa/mv88e6060.c
>     fix warning in fs/dlm/netlink.c
>     fix warning in drivers/net/sis900.c

Applied

>     fix warning in drivers/net/wireless/iwlwifi/iwl-3945.c
>     fix warning in drivers/net/wireless/b43/main.c
>     fix warning in drivers/net/wireless/ath9k/rc.c

Needs to be submitted via wireless folks at linux-wireless

>     fix warning in drivers/net/wan/z85230.c
>     fix error path in drivers/net/mlx4/en_rx.c
>     fix warning in drivers/net/cassini.c
>     fix warning in net/dccp/options.c
>     fix warning in drivers/net/mlx4/mcg.c
>     fix warning in net/ax25/sysctl_net_ax25.c
>     fix warning in net/sunrpc/xprtrdma/verbs.c
>     fix warning in net/bluetooth/rfcomm/sock.c

Applied.

>     fix warning in drivers/net/wireless/ray_cs.c

Submit to wireless maintainer please.

>     fix warning in net/netfilter/nf_conntrack_proto_sctp.c
>     fix warning in net/netfilter/ipvs/ip_vs_ctl.c

Patrick got these.

>     fix warning in drivers/net/atlx/atl2.c

Applied.

>     fix warning in net/netfilter/nf_conntrack_proto_tcp.c

Patrick got it.

>     fix warning in drivers/net/wireless/iwlwifi/iwl-scan.c

Wireless submission please.

>     fix warning in drivers/net/depca.c
>     fix warning in drivers/net/3c523.c

Applied.

>     drivers/net/wireless/b43/phy_g.c: type check debug printouts

Submit to wireless folks please.

>     fix warning in drivers/net/sky2.c
>     fix warning in net/sunrpc/svcauth_unix.c
>     fix warning in security/selinux/netnode.c
>     fix warning in net/packet/af_packet.c
>     fix warning in net/rfkill/rfkill.c

Not applied.  Changing this from a BUG() to a panic() is wrong.
BUG() kills the current execution context, and allows the system
to potentially continue.  Panic() takes down the entire machine.

The !CONFIG_BUG BUG() definition should be marked in such a way
that gcc thinks it is noreturn.  Otherwise BUG() isn't really
BUG() anymore.  The other option is to never allow BUG to be
disabled or have it always evaluate to a simple bug trap.
