Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37536 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbeKPQI1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:08:27 -0500
Date: Fri, 16 Nov 2018 13:56:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        paulmck@linux.ibm.com, steffen.klassert@secunet.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 09/41] crypto/pcrypt: Replace
 synchronize_rcu_bh() with synchronize_rcu()
Message-ID: <20181116055640.72omc5p5bu6nfyuc@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181111194410.6368-9-paulmck@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> Now that synchronize_rcu() waits for bh-disable regions of code as
> well as RCU read-side critical sections, the synchronize_rcu_bh() in
> pcrypt_cpumask_change_notify() can be replaced by synchronize_rcu().
> This commit therefore makes this change.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: <linux-crypto@vger.kernel.org>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
