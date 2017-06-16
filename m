From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net-next 3/4] tls: kernel TLS support
Date: Fri, 16 Jun 2017 13:58:46 -0700
Message-ID: <20170616135846.6d6011db@xeon-e3>
References: <cover.1497465295.git.davejwatson@fb.com>
        <20170614183739.GA80368@davejwatson-mba.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ilya Lesokhin <ilyal@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Matan Barak <matanb@mellanox.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <nmav@gnutls.org>, <fridolin.pokorny@gmail.com>
To: Dave Watson <davejwatson@fb.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:32821 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdFPU6x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 16:58:53 -0400
Received: by mail-pf0-f175.google.com with SMTP id 83so27414566pfr.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2017 13:58:53 -0700 (PDT)
In-Reply-To: <20170614183739.GA80368@davejwatson-mba.dhcp.thefacebook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 14 Jun 2017 11:37:39 -0700
Dave Watson <davejwatson@fb.com> wrote:

> --- /dev/null
> +++ b/net/tls/Kconfig
> @@ -0,0 +1,12 @@
> +#
> +# TLS configuration
> +#
> +config TLS
> +	tristate "Transport Layer Security support"
> +	depends on NET
> +	default m
> +	---help---
> +	Enable kernel support for TLS protocol. This allows symmetric
> +	encryption handling of the TLS protocol to be done in-kernel.
> +
> +	If unsure, say M.

I understand that this will be useful to lots of people and most distributions
will enable it. But the defacto policy in kernel configuration has been that
new features in kernel default to being disabled.
