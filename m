From: "Kabir Ahsan-r9aahw" <Ahsan.Kabir@freescale.com>
Subject: [Openswan dev] Openswan OCF : ----- USE_BATCH mode + ERESTART
Date: Mon, 4 Dec 2006 10:26:41 -0700
Message-ID: <351763BE49AC8743AFCCF925821FF6BE015036AE@az33exm22.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0303934571=="
Cc: linux-crypto@vger.kernel.org
Return-path: <dev-bounces@openswan.org>
Content-class: urn:content-classes:message
To: <dev@openswan.org>
List-Unsubscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=unsubscribe>
List-Archive: <http://lists.openswan.org/pipermail/dev>
List-Post: <mailto:dev@openswan.org>
List-Help: <mailto:dev-request@openswan.org?subject=help>
List-Subscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=subscribe>
Sender: dev-bounces@openswan.org
Errors-To: dev-bounces@openswan.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.

--===============0303934571==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C717C9.5D0D73E7"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C717C9.5D0D73E7
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi All
I am trying to get the USE_BATCH (=3D1) mode to work for my crypto =
driver.
I guess I have found some problem, that is, crypto driver signals
ERESTART as a function call return (line 1317 below), then the crypto
thread sets the cc_qblocked to 1 (line 1333 below).
=20
  1303                 if (submit !=3D NULL) {
   1304                         /* AK added */
   1305                         //if (!( gKeepTrackOfCryptoThread %
100)) {
   1306                         //      printk("6," );
   1307                         //}
   1308                         list_del(&submit->crp_list);
   1309                         CRYPTO_Q_UNLOCK();
   1310
   1311                         //trace_set_L1(c,30); /* 30 is the id
for OCF code */
   1312                         //trace_set_L1(f,7); /* trace point */
   1313                         //trace_log_L1(trace_var(c),
trace_var(f), 200); /* log */
   1314
   1315                         result =3D crypto_invoke(submit, hint);
   1316                         CRYPTO_Q_LOCK();
   1317                         if (result =3D=3D ERESTART) {
   1318
   1319                                 /* AK added */
   1320                                 //if (!(
gKeepTrackOfCryptoThread % 100)) {
   1321                                 //      printk("7," );
   1322                                 //}
   1323                                 /*
   1324                                  * The driver ran out of
resources, mark the
   1325                                  * driver ``blocked'' for
cryptop's and put
   1326                                  * the request back in the
queue.  It would
   1327                                  * best to put the request back
where we got
   1328                                  * it but that's hard so for now
we put it
   1329                                  * at the front.  This should be
ok; putting
   1330                                  * it at the end does not work.
   1331                                  */
   1332                                 /* XXX validate sid again? */
   1333
crypto_drivers[CRYPTO_SESID2HID(submit->crp_sid)].cc_qblocked =3D 1
;
   1334                                 list_add(&submit->crp_list,
&crp_q);
   1335                                 cryptostats.cs_blocks++;
   1336                         }
   1337                 }

=20
Because the crypto hardware is not able to cope up with the request now
it makes sense for the crypto thread to go to sleep and later be
awakened by the crypto driver. But I guess this thread doesn't go to
sleep because the wait_on_event condition argument is not turning out to
be false. Here is the code segment. Line 1414 should put the thread to
sleep but it does not because the submit queue is not empty, when crypto
driver returned ERESTART.=20
=20
   1375                 if (submit =3D=3D NULL && krp =3D=3D NULL) {
   1376                         /* AK added */
   1377                         //if (!( gKeepTrackOfCryptoThread %
100)) {
   1378                         //      printk("8," );
   1379                         //}
   1380                         /*
   1381                          * Nothing more to be processed.  Sleep
until we're
   1382                          * woken because there are more ops to
process.
   1383                          * This happens either by submission or
by a driver
   1384                          * becoming unblocked and notifying us
through
   1385                          * crypto_unblock.  Note that when we
wakeup we
   1386                          * start processing each queue again
from the
   1387                          * front. It's not clear that it's
important to
   1388                          * preserve this ordering since ops may
finish
   1389                          * out of order if dispatched to
different devices
   1390                          * and some become blocked while others
do not.
   1391                          */
   1392                         //printk("1 : sleeping \n");
   1393                         dprintk("%s - sleeping\n",
__FUNCTION__);
   1394                         CRYPTO_Q_UNLOCK();
   1395
   1414
wait_event_interruptible(cryptoproc_wait,
   1415                                         cryptoproc =3D=3D =
(pid_t) -1
||
   1416                                         !list_empty(&crp_q) ||
   1417                                         !list_empty(&crp_kq));
   1418                         ...

=20
=20
>From the crypto driver routine I call crypto_unblock and believe the
purpose of this is to wake up the crypto thread. In the first place this
thread didn't go to sleep. Am I missing something? How this scheme is
supposed to work? Didn't anyone run into ERESTART condition and was able
to get out this condition gracefully? This ERESTART problem will show up
more when the injected traffic to the VPN testbed is very high. For
instance, in the lab I was blasting 100% of line rate (gigabit) with
packet size of 1024B.=20
=20
Please shed some light.
=20
Ahsan.=20

------_=_NextPart_001_01C717C9.5D0D73E7
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.2180" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D408381517-04122006>Hi=20
All</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D408381517-04122006>I am =
trying to get=20
the USE_BATCH (=3D1) mode to work for my crypto driver.&nbsp;&nbsp;I =
guess I have=20
found some problem, that is, crypto driver signals ERESTART as a =
function call=20
return (line 1317 below), then the&nbsp;crypto thread sets the =
cc_qblocked to 1=20
(line 1333 below).</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D408381517-04122006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D408381517-04122006>&nbsp; =

1</SPAN>303&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
if (submit !=3D NULL) {<BR>&nbsp;&nbsp;=20
1304&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
/* AK added */<BR>&nbsp;&nbsp;=20
1305&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//if (!( gKeepTrackOfCryptoThread % 100)) {<BR>&nbsp;&nbsp;=20
1306&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk("6," );<BR>&nbsp;&nbsp;=20
1307&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//}<BR>&nbsp;&nbsp;=20
1308&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
list_del(&amp;submit-&gt;crp_list);<BR>&nbsp;&nbsp;=20
1309&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
CRYPTO_Q_UNLOCK();<BR>&nbsp;&nbsp; 1310<BR>&nbsp;&nbsp;=20
1311&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//trace_set_L1(c,30); /* 30 is the id for OCF code */<BR>&nbsp;&nbsp;=20
1312&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//trace_set_L1(f,7); /* trace point */<BR>&nbsp;&nbsp;=20
1313&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//trace_log_L1(trace_var(c), trace_var(f), 200); /* log =
*/<BR>&nbsp;&nbsp;=20
1314<BR>&nbsp;&nbsp;=20
1315&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
result =3D crypto_invoke(submit, hint);<BR>&nbsp;&nbsp;=20
1316&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
CRYPTO_Q_LOCK();<BR>&nbsp;&nbsp;=20
1317&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
if (result =3D=3D ERESTART) {<BR>&nbsp;&nbsp; 1318<BR>&nbsp;&nbsp;=20
1319&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/* AK added */<BR>&nbsp;&nbsp;=20
1320&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
//if (!( gKeepTrackOfCryptoThread % 100)) {<BR>&nbsp;&nbsp;=20
1321&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
//&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk("7," );<BR>&nbsp;&nbsp;=20
1322&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
//}<BR>&nbsp;&nbsp;=20
1323&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/*<BR>&nbsp;&nbsp;=20
1324&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
* The driver ran out of resources, mark the<BR>&nbsp;&nbsp;=20
1325&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
* driver ``blocked'' for cryptop's and put<BR>&nbsp;&nbsp;=20
1326&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
* the request back in the queue.&nbsp; It would<BR>&nbsp;&nbsp;=20
1327&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
* best to put the request back where we got<BR>&nbsp;&nbsp;=20
1328&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
* it but that's hard so for now we put it<BR>&nbsp;&nbsp;=20
1329&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
* at the front.&nbsp; This should be ok; putting<BR>&nbsp;&nbsp;=20
1330&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
* it at the end does not work.<BR>&nbsp;&nbsp;=20
1331&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
*/<BR>&nbsp;&nbsp;=20
1332&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/* XXX validate sid again? */<BR>&nbsp;&nbsp;=20
1333&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
crypto_drivers[CRYPTO_SESID2HID(submit-&gt;crp_sid)].cc_qblocked =3D=20
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;<BR>&nbsp;&nbsp;=20
1334&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
list_add(&amp;submit-&gt;crp_list, &amp;crp_q);<BR>&nbsp;&nbsp;=20
1335&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
cryptostats.cs_blocks++;<BR>&nbsp;&nbsp;=20
1336&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
}<BR>&nbsp;&nbsp;=20
1337&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;=20
}<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial =
size=3D2>Because the=20
crypto hardware is not able to cope up with the request now it makes =
sense for=20
the crypto thread to go to sleep and later be awakened by the crypto =
driver. But=20
I guess this thread doesn't go to sleep because the wait_on_event =
condition=20
argument is not turning out to be false. Here is the code segment. Line =
1414=20
should put the thread to sleep but it does not because the submit queue =
is not=20
empty, when crypto driver returned ERESTART. </FONT></SPAN></FONT></DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial=20
size=3D2></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial =
size=3D2>&nbsp;=20
&nbsp;1375&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
if (submit =3D=3D NULL &amp;&amp; krp =3D=3D NULL) {<BR>&nbsp;&nbsp;=20
1376&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
/* AK added */<BR>&nbsp;&nbsp;=20
1377&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//if (!( gKeepTrackOfCryptoThread % 100)) {<BR>&nbsp;&nbsp;=20
1378&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk("8," );<BR>&nbsp;&nbsp;=20
1379&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//}<BR>&nbsp;&nbsp;=20
1380&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
/*<BR>&nbsp;&nbsp;=20
1381&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* Nothing more to be processed.&nbsp; Sleep until we're<BR>&nbsp;&nbsp;=20
1382&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* woken because there are more ops to process.<BR>&nbsp;&nbsp;=20
1383&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* This happens either by submission or by a driver<BR>&nbsp;&nbsp;=20
1384&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* becoming unblocked and notifying us through<BR>&nbsp;&nbsp;=20
1385&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* crypto_unblock.&nbsp; Note that when we wakeup we<BR>&nbsp;&nbsp;=20
1386&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* start processing each queue again from the<BR>&nbsp;&nbsp;=20
1387&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* front. It's not clear that it's important to<BR>&nbsp;&nbsp;=20
1388&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* preserve this ordering since ops may finish<BR>&nbsp;&nbsp;=20
1389&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* out of order if dispatched to different devices<BR>&nbsp;&nbsp;=20
1390&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
* and some become blocked while others do not.<BR>&nbsp;&nbsp;=20
1391&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20
*/<BR>&nbsp;&nbsp;=20
1392&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
//printk("1 : sleeping \n");<BR>&nbsp;&nbsp;=20
1393&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
dprintk("%s - sleeping\n", __FUNCTION__);<BR>&nbsp;&nbsp;=20
1394&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
CRYPTO_Q_UNLOCK();<BR>&nbsp;&nbsp;=20
1395<BR>&nbsp;&nbsp;&nbsp;1414&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
wait_event_interruptible(cryptoproc_wait,<BR>&nbsp;&nbsp;=20
1415&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
cryptoproc =3D=3D (pid_t) -1 ||<BR>&nbsp;&nbsp;=20
1416&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
!list_empty(&amp;crp_q) ||<BR>&nbsp;&nbsp;=20
1417&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
!list_empty(&amp;crp_kq));<BR>&nbsp;&nbsp;=20
1418&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
...</FONT></SPAN></FONT></DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial=20
size=3D2><BR></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial=20
size=3D2></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial =
size=3D2>From the=20
crypto driver routine I call crypto_unblock and believe the purpose of =
this is=20
to wake up the crypto thread. In the first place this thread didn't go =
to sleep.=20
Am I missing something? How this scheme is supposed to work? Didn't =
anyone run=20
into ERESTART condition and was able to get out this condition =
gracefully? This=20
ERESTART problem will show up more when the injected traffic to the=20
VPN&nbsp;testbed is very high. For instance, in the lab I was blasting =
100% of=20
line rate (gigabit) with packet size of 1024B. =
</FONT></SPAN></FONT></DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial=20
size=3D2></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial =
size=3D2>Please shed=20
some light.</FONT></SPAN></FONT></DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial=20
size=3D2></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D408381517-04122006><FONT face=3DArial =
size=3D2>Ahsan.=20
</DIV></FONT></SPAN></FONT></BODY></HTML>

------_=_NextPart_001_01C717C9.5D0D73E7--

--===============0303934571==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Dev mailing list
Dev@openswan.org
http://lists.openswan.org/mailman/listinfo/dev

--===============0303934571==--
