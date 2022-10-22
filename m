Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5073CC433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Oct 2022 03:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiJVDAZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJVDAX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 23:00:23 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CC01EC63
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2022 20:00:20 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 137so3788135iou.9
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2022 20:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beepnowsys-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mS5Q9YTS8xFpJwqwrWPo55ClD1B0cI9P/qdplG7CODw=;
        b=J9QIUb22el1JFM74aa3IlGzPEwghLn5/9CYUeTKv9GPcPTYp4hhDeLXv8KYILHQaco
         QgWjvIxFEW/qLiyWLeoFdLY35/XoiJeXuJayZJ9YI7Jb0oU822KuOio8xWaf76YYu1cv
         sBCm/xSYUm1imyA7DBrktH15czHQ+AgOdzTMu895daG0/EEo5SrNs9YYLArkNlK5M4NR
         5xOeIoD2e/6abcTDYotE4a4DITTSdIeEu/pnaSwJ2GARVR6xNTGnZdfseXEL783ikVx3
         t+2dmwEGCJ6oeTl5WjvT03mND6ir7ERqLEj1CaBfBNTC05xduSKWWO6PgoAXfqIrn/UU
         OVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mS5Q9YTS8xFpJwqwrWPo55ClD1B0cI9P/qdplG7CODw=;
        b=LNkCWEyHxZqk/+Z2HVvOUroAEEXLlIRHynf6FHLiDAMWbqBG7N7k8mA4spLbqW0Xqg
         lyrxSqbLBVUCjZ+LaWM7SaQXo/wXRFVkLSSqESFtgFq1RVMyXz3XQlTMqTdV+sviYSmf
         m2+L2Q4PuTAch6tWfpP11nJlOPzGvGV5bCRCxMCjZ8R/mErYTQX0G39AXKID8bmzVcam
         28XtlK4jXRim+cUSSjNrQw+dPGIJZYonJ6gjneYJkEffShJhQVeja+xrs7pnB9GAAY4Y
         C+j3uqK2iwdHW7j99q5MTTLTvTCjpKY+2HUkeiRBhcipy+v+VJ3KrW0YUwaSLCj7iarK
         9mLw==
X-Gm-Message-State: ACrzQf3T/heOJ4znEjznWTyO1i9IVKvfnqWw2HU8D71wMIC2okADyefV
        L+We+QFC6dhJXRuRT7RDcSkwE748NbnvkT5fNbgGv7Q7szwWHg==
X-Google-Smtp-Source: AMsMyM7sb4gZK+0tKXCyyiBf8NHfRliu6WbCwqhI4QmAOPxw1py4GI8rH+/UlV+XSgyA64DjwOcnEET8+iQH3VVFG7g=
X-Received: by 2002:a05:6638:3802:b0:351:d8a5:6d58 with SMTP id
 i2-20020a056638380200b00351d8a56d58mr17436569jav.206.1666407619453; Fri, 21
 Oct 2022 20:00:19 -0700 (PDT)
Received: from 185469646988 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 22 Oct 2022 04:00:18 +0100
MIME-Version: 1.0
Sender: hello@beepnowsys.com
From:   hello@beepnowsys.com
Date:   Sat, 22 Oct 2022 04:00:18 +0100
X-Google-Sender-Auth: Kyufdqfd92w9vyS61TsO6RLvGnY
Message-ID: <CAHa8Zt41BYZdZ31fH-Qm8f92wD_v02omc1VbuHKZXdfKdtTpHQ@mail.gmail.com>
Subject: =?UTF-8?B?44CQYmVlcOS6uuS6i+OAkeOBiuWVj+OBhOWQiOOCj+OBm+OBguOCiuOBjOOBqOOBhuOBlA==?=
        =?UTF-8?B?44GW44GE44G+44GZ44CC?=
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

44GK5ZWP44GE5ZCI44KP44Gb44GC44KK44GM44Go44GG44GU44GW44GE44G+44GZ44CCDQrkuIvo
qJjjga7jgajjgYrjgorjgYrllY/jgYTlkIjjgo/jgZvjgpLlj5fjgZHku5jjgZHjgb7jgZfjgZ/j
gIINCg0K4pag44K/44Kk44Og44K544K/44Oz44OXDQpTYXQgT2N0IDIyIDIwMjIgMTI6MDA6MTIg
R01UKzA5MDAgKOaXpeacrOaomea6luaZgikNCg0K4pag44GK5ZCN5YmNDQo1MTI1NDQNCg0K4pag
5Lya56S+5ZCNDQpmcmVlX3NleF9pbmZvDQogbmhnLnBhZ2UubGluay9rdzRKIw0KTGl4DQoNCuKW
oOmbu+ipseeVquWPtw0KDQoNCuKWoOalreeorg0KDQoNCuKWoG1haWwNCmxpbnV4LWNyeXB0b0B2
Z2VyLmtlcm5lbC5vcmcNCg0K4pag44GK5ZWP44GE5ZCI44KP44Gb56iu5YilDQo/Pz8NCg0K4pag
5oOz5a6a5Yip55So5Lq65pWwDQozMDA/fjUwMD8NCg0K4pagYmVlcOS6uuS6i+OCkuaknOiojuOB
l+OBpuOBhOOCi+eQhueUsQ0KPz8/DQoNCuKWoOOBneOBruS7lg0KDQoNCuKWoOOBiuWVj+OBhOWQ
iOOCj+OBm+WGheWuuQ0KDQoNCuKWoOacgOaWsOOBruS6uuS6i+ipleS+oeODhOODvOODq+OBq+WQ
iOOCj+OBm+OBn+S6uuS6i+ipleS+oeWItuW6puioreioiOOBq+OBlOiIiOWRs+OBlOOBluOBhOOB
vuOBmeOBi++8nw0KPz8NCg0KDQrlhoXlrrnjgpLnorroqo3jga7kuIrjgIHjgYLjgonjgZ/jgoHj
gabov5Tkv6HjgZXjgZvjgabjgYTjgZ/jgaDjgY3jgb7jgZnjgIINCuacrOODoeODvOODq+OBq+W/
g+W9k+OBn+OCiuOBjOeEoeOBhOWgtOWQiOOBr+OAgeOBneOBruaXqOOCkuiomOi8ieOBruS4iuOB
lOi/lOS/oeS4i+OBleOBhOOBvuOBmeOCiOOBhuOBiumhmOOBhOeUs+OBl+S4iuOBkuOBvuOBmeOA
gg0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCmJlZXBub3cgc3lzdGVtc+agquW8j+S8muekvg0K5L2P5omA77ya44CSMTA0LTAw
NTMg5p2x5Lqs6YO95Lit5aSu5Yy65pm05rW377yT5LiB55uu77yR77yQ4oiS77yRIERhaXdhIOaZ
tOa1t+ODk+ODqzJGDQpURUzvvJowNTAtNTgwNi05NzAzDQpVUkzvvJpodHRwczovL2JlZXBub3dz
eXMuY29tDQpiZWVw5Lq65LqL77yaaHR0cHM6Ly9iaXQubHkvM2MxeXM3Vw0KTWFpbO+8mmhlbGxv
QGJlZXBub3dzeXMuY29tDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCg==
