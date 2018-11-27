Return-Path: <SRS0=NopL=OG=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726288AbeK1ESp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Nov 2018 23:18:45 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wARHK923122835
        for <linux-crypto@vger.kernel.org>; Tue, 27 Nov 2018 12:20:10 -0500
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p17j3829x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 27 Nov 2018 12:20:09 -0500
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 27 Nov 2018 17:20:01 -0000
Date: Tue, 27 Nov 2018 09:19:54 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 09/41] crypto/pcrypt: Replace
 synchronize_rcu_bh() with synchronize_rcu()
Reply-To: paulmck@linux.ibm.com
References: <20181111194410.6368-9-paulmck@linux.ibm.com>
 <20181116055640.72omc5p5bu6nfyuc@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116055640.72omc5p5bu6nfyuc@gondor.apana.org.au>
Message-Id: <20181127171954.GQ4170@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 16, 2018 at 01:56:40PM +0800, Herbert Xu wrote:
> Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> > Now that synchronize_rcu() waits for bh-disable regions of code as
> > well as RCU read-side critical sections, the synchronize_rcu_bh() in
> > pcrypt_cpumask_change_notify() can be replaced by synchronize_rcu().
> > This commit therefore makes this change.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
> > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > Cc: <linux-crypto@vger.kernel.org>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thank you!

							Thanx, Paul
