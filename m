From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 1/4] tcp: ULP infrastructure
Date: Wed, 07 Jun 2017 14:48:03 -0400 (EDT)
Message-ID: <20170607.144803.1105141240150759683.davem@davemloft.net>
References: <cover.1496767702.git.davejwatson@fb.com>
        <20170606170020.GA19182@davejwatson-mba.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ilyal@mellanox.com, aviadye@mellanox.com, borisp@mellanox.com,
        liranl@mellanox.com, matanb@mellanox.com, netdev@vger.kernel.org,
        tom@herbertland.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, hannes@stressinduktion.org,
        eric.dumazet@gmail.com, alexei.starovoitov@gmail.com,
        nmav@gnutls.org, fridolin.pokorny@gmail.com
To: davejwatson@fb.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170606170020.GA19182@davejwatson-mba.local>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dave Watson <davejwatson@fb.com>
Date: Tue, 6 Jun 2017 10:00:20 -0700

> +EXPORT_SYMBOL(tcp_register_ulp);

EXPORT_SYMBOL_GPL() please.

> +EXPORT_SYMBOL(tcp_unregister_ulp);

Likewise.
