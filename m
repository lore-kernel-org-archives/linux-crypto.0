From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 1/4] crypto: talitos: dma_map_sg can handle chained SG
Date: Wed, 23 Sep 2015 14:07:22 +0200
Message-ID: <560295FA.7070005@c-s.fr>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
 <1443009328-12478-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443009328-12478-2-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Le 23/09/2015 13:55, LABBE Corentin a =E9crit :
> The talitos driver use two dma_map_sg path
> according to SG are chained or not.
> Since dma_map_sg can handle both case, clean the code with all
> references to sg chained.
>
> Thus removing talitos_map_sg, talitos_unmap_sg_chain
> and sg_count functions.
>
>
Shouldn't the replacement of sg_count()  by sg_nents_for_len() be part=20
of second patch ?

Christophe
