From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH 13/14] crypto: drivers - remove cra_list initialization
Date: Wed, 18 Jul 2012 04:04:19 +0300
Message-ID: <50060B93.3070503@mentor.com>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6> <20120711112056.6875.58905.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	<linux-geode@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:60383 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2GRBEc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jul 2012 21:04:32 -0400
In-Reply-To: <20120711112056.6875.58905.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11.07.2012 14:20, Jussi Kivilinna wrote:
> Initialization of cra_list is currently mixed, most ciphers initializ=
e this
> field and most shashes do not. Initialization however is not needed a=
t all
> since cra_list is initialized/overwritten in __crypto_register_alg() =
with
> list_add(). Therefore perform cleanup to remove all unneeded initiali=
zations
> of this field in 'crypto/drivers/'.
>
> Cc: Kent Yoder<key@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> Cc: linux-geode@lists.infradead.org
> Cc: Michal Ludvig<michal@logix.cz>
> Cc: Dmitry Kasatkin<dmitry.kasatkin@nokia.com>
> Cc: Varun Wadekar<vwadekar@nvidia.com>
> Cc: Vladimir Zapolskiy<vzapolskiy@gmail.com>
> Cc: Eric B=C3=A9nard<eric@eukrea.com>
> Signed-off-by: Jussi Kivilinna<jussi.kivilinna@mbnet.fi>

Acked-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>

Thanks,
Vladimir
