From: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 2/3] crypto: brcm: Add Broadcom SPU driver
Date: Thu, 2 Feb 2017 10:11:57 -0500
Message-ID: <E8AAEF8D-B4B1-4716-BDE2-A533EDA828A1@broadcom.com>
References: <1485362689-11294-1-git-send-email-rob.rice@broadcom.com> <1485362689-11294-3-git-send-email-rob.rice@broadcom.com> <20170202140510.GB5289@gondor.apana.org.au>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170202140510.GB5289-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Herbert,


> On Feb 2, 2017, at 9:05 AM, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> =
wrote:
>=20
> On Wed, Jan 25, 2017 at 11:44:48AM -0500, Rob Rice wrote:
>>=20
>> +static int ahash_export(struct ahash_request *req, void *out)
>> +{
>> +	const struct iproc_reqctx_s *rctx =3D ahash_request_ctx(req);
>> +
>> +	memcpy(out, rctx, offsetof(struct iproc_reqctx_s, msg_buf));
>> +	return 0;
>> +}
>=20
> The reqctx data structure seems to contain a lot of info unrelated
> to the hash state.  Can't we get away with just copying the hash
> state (incr_hash) itself?

Yes, I see your point. I=E2=80=99ll whittle the export state down to =
just what=E2=80=99s needed for the hash.

>=20
> Cheers,
> --=20
> Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
