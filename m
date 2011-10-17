From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH v2.1 4/7] crypto: GnuPG based MPI lib - additional sources
 (part 4)
Date: Mon, 17 Oct 2011 12:09:21 +0300
Message-ID: <CALLzPKbdM3Q3i-wuqqemMQzP9AWGnVki7SOAmRu9z-u0o8uGkA@mail.gmail.com>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com>
	<81f834dca8feb889e2acbc666e730cf89b5d5c41.1318598705.git.dmitry.kasatkin@intel.com>
	<alpine.LRH.2.00.1110151132430.24994@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.hengli.com.au
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:36196 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750902Ab1JQJJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Oct 2011 05:09:26 -0400
In-Reply-To: <alpine.LRH.2.00.1110151132430.24994@tundra.namei.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 15, 2011 at 3:34 AM, James Morris <jmorris@namei.org> wrote=
:
> On Fri, 14 Oct 2011, Dmitry Kasatkin wrote:
>
>> +#if 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* not yet ported to M=
PI */
>> +
>> +mpi_limb_t
>> +mpihelp_udiv_w_sdiv(mpi_limp_t *rp,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_limp_t=
 *a1, mpi_limp_t *a0, mpi_limp_t *d)
>
> Drop this if it's not working.
>
>
> --
> James Morris
> <jmorris@namei.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-secur=
ity-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

It is there for completeness and it will not be even compiled at all
without CONFIG_MPILIB_EXTRA

Still remove?

- Dmitry
