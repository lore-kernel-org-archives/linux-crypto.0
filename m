From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2] dm: switch dm-verity to async hash crypto
	API
Date: Fri, 17 Feb 2017 16:47:11 +0200
Message-ID: <CAOtvUMc7s-ymufSiEty-vifcp12_TMnVMq6=mLcuz60T7RgnNQ@mail.gmail.com>
References: <1486389482-26992-1-git-send-email-gilad@benyossef.com>
	<74bc1a00-6fb4-4b2f-b57b-a7fea0969eeb@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3511730223519518954=="
Cc: Mike Snitzer <snitzer@redhat.com>, gilad.benyossef@arm.com,
        Eric Biggers <ebiggers3@gmail.com>, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek+linux-crypto@gmail.com>,
        Alasdair Kergon <agk@redhat.com>, Ofir Drang <ofir.drang@arm.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <74bc1a00-6fb4-4b2f-b57b-a7fea0969eeb@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

--===============3511730223519518954==
Content-Type: multipart/alternative; boundary=001a113f26ba2b17500548bafd01

--001a113f26ba2b17500548bafd01
Content-Type: text/plain; charset=UTF-8

Hi Milan,

Thank you for the review and testing.

On Fri, Feb 17, 2017 at 3:00 PM, Milan Broz <gmazyland@gmail.com> wrote:

> On 02/06/2017 02:58 PM, Gilad Ben-Yossef wrote:
> > Use of the synchronous digest API limits dm-verity to using pure
> > CPU based algorithm providers and rules out the use of off CPU
> > algorithm providers which are normally asynchronous by nature,
> > potentially freeing CPU cycles.
> >
> > This can reduce performance per Watt in situations such as during
> > boot time when a lot of concurrent file accesses are made to the
> > protected volume.
> >
> > Move DM_VERITY to the asynchronous hash API.
>
> Did you test that async hash completion path?
>
> Yes, I did - with the Arm TrustZone CryptoCell hardware accelerator.
I did not try with cryptd though.



> I just tried to force async crypto by replacing "sha256"
> in mapping table with "cryptd(sha256-generic)" and it kills
> kernel immediately.
> https://mbroz.fedorapeople.org/tmp/verity-fail.png
>
> (I hope this trick should cause to use cryptd and use async processing.
> In previous version the parameter is properly rejected, because unsupported
> by shash api.)
>
>
>
Thanks for this trick. I was not aware you can invoke cryptd it like that.

I will recreate the issue and fix it.

Some more comments below.
> ...
>
> > -static int verity_hash_update(struct dm_verity *v, struct shash_desc
> *desc,
> > -                           const u8 *data, size_t len)
> > +static int verity_hash_update(struct dm_verity *v, struct ahash_request
> *req,
> > +                             const u8 *data, size_t len,
> > +                             struct verity_result *res)
> >  {
> > -     int r = crypto_shash_update(desc, data, len);
> > +     struct scatterlist sg;
> >
> > -     if (unlikely(r < 0))
> > -             DMERR("crypto_shash_update failed: %d", r);
> > +     sg_init_table(&sg, 1);
> > +     sg_set_buf(&sg, data, len);
>
> No good reason. I will amend it in the next revision.
>



> +     ahash_request_set_crypt(req, &sg, NULL, len);
> > +
> > +     return verity_complete_op(res, crypto_ahash_update(req));
> > +}
>
> ...
>
> > -int verity_hash(struct dm_verity *v, struct shash_desc *desc,
> > +int verity_hash(struct dm_verity *v, struct ahash_request *req,
> >               const u8 *data, size_t len, u8 *digest)
> >  {
> >       int r;
> > +     struct verity_result res;
> >
> > -     r = verity_hash_init(v, desc);
> > +     r = verity_hash_init(v, req, &res);
> >       if (unlikely(r < 0))
> > -             return r;
> > +             goto out;
>
> why it is changed to goto? it doesn't simplify anything in this function
>
>
I generally prefer for a function to have a single return point, if it does
not over complicates things. I find it makes code more readable and easier
to reason about - put debugging log statement for return for example.



> >
> > -     r = verity_hash_update(v, desc, data, len);
> > +     r = verity_hash_update(v, req, data, len, &res);
> >       if (unlikely(r < 0))
> > -             return r;
> > +             goto out;
> > +
> > +     r = verity_hash_final(v, req, digest, &res);
> >
> > -     return verity_hash_final(v, desc, digest);
> > +out:
> > +     return r;
> >  }
>
>

I will post a new revision of the patch early next week  .

Thanks,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a situation
where the homework eats your dog?"
 -- Jean-Baptiste Queru

--001a113f26ba2b17500548bafd01
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Milan,<div><br></div><div>Thank you for the review and =
testing.<br><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fr=
i, Feb 17, 2017 at 3:00 PM, Milan Broz <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:gmazyland@gmail.com" target=3D"_blank">gmazyland@gmail.com</a>&gt;</spa=
n> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 02/06/2017 =
02:58 PM, Gilad Ben-Yossef wrote:<br>
&gt; Use of the synchronous digest API limits dm-verity to using pure<br>
&gt; CPU based algorithm providers and rules out the use of off CPU<br>
&gt; algorithm providers which are normally asynchronous by nature,<br>
&gt; potentially freeing CPU cycles.<br>
&gt;<br>
&gt; This can reduce performance per Watt in situations such as during<br>
&gt; boot time when a lot of concurrent file accesses are made to the<br>
&gt; protected volume.<br>
&gt;<br>
&gt; Move DM_VERITY to the asynchronous hash API.<br>
<br>
</span>Did you test that async hash completion path?<br>
<br></blockquote><div>Yes, I did - with the Arm TrustZone CryptoCell hardwa=
re accelerator.</div><div>I did not try with cryptd though.</div><div><br><=
/div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
I just tried to force async crypto by replacing &quot;sha256&quot;<br>
in mapping table with &quot;cryptd(sha256-generic)&quot; and it kills<br>
kernel immediately.<br>
<a href=3D"https://mbroz.fedorapeople.org/tmp/verity-fail.png" rel=3D"noref=
errer" target=3D"_blank">https://mbroz.fedorapeople.<wbr>org/tmp/verity-fai=
l.png</a><br>
<br>
(I hope this trick should cause to use cryptd and use async processing.<br>
In previous version the parameter is properly rejected, because unsupported=
<br>
by shash api.)<br>
<br>
<br></blockquote><div><br></div><div>Thanks for this trick. I was not aware=
 you can invoke cryptd it like that.</div><div><br></div><div>I will recrea=
te the issue and fix it.</div><div><br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>
Some more comments below.<br>
...<br>
<span class=3D""><br>
&gt; -static int verity_hash_update(struct dm_verity *v, struct shash_desc =
*desc,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0const u8 *data, size_t len)<br>
&gt; +static int verity_hash_update(struct dm_verity *v, struct ahash_reque=
st *req,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const u8 *data, size_t len,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct verity_result *res)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int r =3D crypto_shash_update(desc, data, len);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0struct scatterlist sg;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (unlikely(r &lt; 0))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DMERR(&quot;crypto_sh=
ash_update failed: %d&quot;, r);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sg_init_table(&amp;sg, 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sg_set_buf(&amp;sg, data, len);<br>
<br>
</span>No good reason. I will amend it in the next revision.<br></blockquot=
e><div><br></div><div><br></div><div><br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><span class=3D"">
&gt; +=C2=A0 =C2=A0 =C2=A0ahash_request_set_crypt(req, &amp;sg, NULL, len);=
<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return verity_complete_op(res, crypto_ahash_updat=
e(req));<br>
&gt; +}<br>
<br>
</span>...<br>
<span class=3D""><br>
&gt; -int verity_hash(struct dm_verity *v, struct shash_desc *desc,<br>
&gt; +int verity_hash(struct dm_verity *v, struct ahash_request *req,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const u8 *data, =
size_t len, u8 *digest)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct verity_result res;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0r =3D verity_hash_init(v, desc);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0r =3D verity_hash_init(v, req, &amp;res);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(r &lt; 0))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
<br>
</span>why it is changed to goto? it doesn&#39;t simplify anything in this =
function<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br></div></div></blockquote><div><=
br></div><div>I generally prefer for a function to have a single return poi=
nt, if it does</div><div>not over complicates things. I find it makes code =
more readable and easier</div><div>to reason about - put debugging log stat=
ement for return for example.</div><div><br></div><div>=C2=A0</div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0r =3D verity_hash_update(v, desc, data, len);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0r =3D verity_hash_update(v, req, data, len, &amp;=
res);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(r &lt; 0))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0r =3D verity_hash_final(v, req, digest, &amp;res)=
;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return verity_hash_final(v, desc, digest);<br>
&gt; +out:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return r;<br>
&gt;=C2=A0 }<br>
<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888"></font></span></=
blockquote><div><br></div><div><br></div><div>I will post a new revision of=
 the patch early next week =C2=A0.</div><div><br></div><div>Thanks,</div><d=
iv>Gilad</div></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature" data-smartmail=3D"gmail_signature">Gilad Ben-Yossef<br=
>Chief Coffee Drinker<br><br>&quot;If you take a class in large-scale robot=
ics, can you end up in a situation where the homework eats your dog?&quot;<=
br>=C2=A0-- Jean-Baptiste Queru</div>
</div></div></div>

--001a113f26ba2b17500548bafd01--


--===============3511730223519518954==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3511730223519518954==--
